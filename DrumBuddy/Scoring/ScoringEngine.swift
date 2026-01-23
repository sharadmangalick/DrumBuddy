//
//  ScoringEngine.swift
//  DrumBuddy
//
//  Scores practice sessions
//

import Foundation

/// Engine for scoring practice attempts
struct ScoringEngine {

    /// Score a practice session
    /// - Parameters:
    ///   - detectedHits: Hits detected from microphone
    ///   - pattern: The pattern being practiced
    ///   - bpm: The tempo used
    /// - Returns: SessionResult with scores and feedback
    static func score(
        detectedHits: [DetectedHit],
        pattern: RhythmPattern,
        bpm: Int
    ) -> SessionResult {
        // Get expected hit times
        let expectedTimes = pattern.hitTimes(atBPM: bpm)
        let toleranceMs = pattern.difficulty.timingToleranceMs

        // Match hits
        let matches = HitMatcher.matchHits(
            detected: detectedHits,
            expectedTimes: expectedTimes,
            toleranceMs: toleranceMs
        )

        // Calculate statistics
        let matchedCount = matches.filter { $0.wasMatched }.count
        let missedCount = matches.filter { !$0.wasMatched }.count
        let extraCount = HitMatcher.countExtraHits(
            detected: detectedHits,
            expectedTimes: expectedTimes,
            toleranceMs: toleranceMs
        )

        // Calculate average offset (only for matched hits)
        let matchedOffsets = matches.compactMap { $0.offsetMs }
        let averageOffset = matchedOffsets.isEmpty ? 0 : matchedOffsets.reduce(0, +) / Double(matchedOffsets.count)

        // Calculate scores
        let hitAccuracyScore = calculateHitAccuracyScore(
            matched: matchedCount,
            expected: expectedTimes.count,
            extra: extraCount
        )

        let timingScore = calculateTimingScore(
            offsets: matchedOffsets,
            toleranceMs: toleranceMs
        )

        // Overall score: 70% hit accuracy, 30% timing
        let overallScore = Int(hitAccuracyScore * 0.7 + timingScore * 0.3)

        // Star rating
        let stars = calculateStars(score: overallScore)

        // Generate feedback message
        let feedback = generateFeedback(
            score: overallScore,
            stars: stars,
            matched: matchedCount,
            expected: expectedTimes.count,
            missed: missedCount,
            extra: extraCount,
            averageOffsetMs: averageOffset
        )

        return SessionResult(
            overallScore: overallScore,
            starRating: stars,
            expectedHits: expectedTimes.count,
            matchedHits: matchedCount,
            extraHits: extraCount,
            missedHits: missedCount,
            averageOffsetMs: averageOffset,
            hitMatches: matches,
            feedbackMessage: feedback
        )
    }

    /// Calculate hit accuracy score (0-100)
    private static func calculateHitAccuracyScore(matched: Int, expected: Int, extra: Int) -> Double {
        guard expected > 0 else { return 0 }

        // Base score from matched hits
        let baseScore = Double(matched) / Double(expected) * 100

        // Penalty for extra hits (5 points each, max 25 point penalty)
        let extraPenalty = min(Double(extra) * 5, 25)

        return max(0, baseScore - extraPenalty)
    }

    /// Calculate timing score (0-100)
    private static func calculateTimingScore(offsets: [Double], toleranceMs: Double) -> Double {
        guard !offsets.isEmpty else { return 0 }

        // Score each offset
        let scores = offsets.map { offset in
            ToleranceCalculator.timingScore(offsetMs: offset, toleranceMs: toleranceMs)
        }

        // Average timing score
        return scores.reduce(0, +) / Double(scores.count) * 100
    }

    /// Calculate star rating
    private static func calculateStars(score: Int) -> Int {
        switch score {
        case 85...100: return 3
        case 60..<85: return 2
        case 30..<60: return 1
        default: return 0
        }
    }

    /// Generate feedback message
    private static func generateFeedback(
        score: Int,
        stars: Int,
        matched: Int,
        expected: Int,
        missed: Int,
        extra: Int,
        averageOffsetMs: Double
    ) -> String {
        // This will be enhanced by FeedbackEngine with TTS
        // Basic feedback for now

        if stars == 3 {
            if matched == expected && extra == 0 {
                return "Perfect! You nailed every beat!"
            }
            return "Great job! You've got the rhythm!"
        }

        if stars == 2 {
            if missed > 0 {
                return "Nice try! You missed \(missed) beat\(missed == 1 ? "" : "s"). Keep practicing!"
            }
            if extra > 0 {
                return "Good effort! Try to match the pattern exactly."
            }
            return "Good job! A little more practice and you'll get 3 stars!"
        }

        if stars == 1 {
            if missed > expected / 2 {
                return "Keep trying! Listen to the pattern again."
            }
            return "You're getting there! Try listening carefully to the rhythm."
        }

        return "Don't give up! Let's try again!"
    }
}
