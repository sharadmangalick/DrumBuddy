//
//  SessionResult.swift
//  DrumBuddy
//
//  Model representing the scored result of a practice session
//

import Foundation

/// Result of scoring a practice session
struct SessionResult: Identifiable, Codable {
    let id: UUID

    /// Overall score (0-100)
    let overallScore: Int

    /// Star rating (0-3)
    let starRating: Int

    /// Number of expected hits in the pattern
    let expectedHits: Int

    /// Number of hits that matched within tolerance
    let matchedHits: Int

    /// Number of extra hits detected (not matching any expected beat)
    let extraHits: Int

    /// Number of missed hits (expected beats with no matching hit)
    let missedHits: Int

    /// Average timing offset in milliseconds (positive = late, negative = early)
    let averageOffsetMs: Double

    /// Individual hit match details
    let hitMatches: [HitMatch]

    /// Feedback message to display
    let feedbackMessage: String

    init(
        id: UUID = UUID(),
        overallScore: Int,
        starRating: Int,
        expectedHits: Int,
        matchedHits: Int,
        extraHits: Int,
        missedHits: Int,
        averageOffsetMs: Double,
        hitMatches: [HitMatch],
        feedbackMessage: String
    ) {
        self.id = id
        self.overallScore = overallScore
        self.starRating = starRating
        self.expectedHits = expectedHits
        self.matchedHits = matchedHits
        self.extraHits = extraHits
        self.missedHits = missedHits
        self.averageOffsetMs = averageOffsetMs
        self.hitMatches = hitMatches
        self.feedbackMessage = feedbackMessage
    }

    /// Percentage of hits matched
    var matchPercentage: Double {
        guard expectedHits > 0 else { return 0 }
        return Double(matchedHits) / Double(expectedHits) * 100
    }

    /// Whether this was a perfect score
    var isPerfect: Bool {
        matchedHits == expectedHits && extraHits == 0
    }
}

/// Details about how a single expected beat was matched
struct HitMatch: Identifiable, Codable {
    let id: UUID

    /// Expected time of the beat (in seconds)
    let expectedTime: TimeInterval

    /// Detected hit time (nil if missed)
    let detectedTime: TimeInterval?

    /// Offset in milliseconds (positive = late, negative = early, nil if missed)
    let offsetMs: Double?

    /// Whether this beat was matched within tolerance
    let wasMatched: Bool

    init(
        id: UUID = UUID(),
        expectedTime: TimeInterval,
        detectedTime: TimeInterval? = nil,
        offsetMs: Double? = nil,
        wasMatched: Bool = false
    ) {
        self.id = id
        self.expectedTime = expectedTime
        self.detectedTime = detectedTime
        self.offsetMs = offsetMs
        self.wasMatched = wasMatched
    }
}
