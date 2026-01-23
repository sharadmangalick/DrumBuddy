//
//  ProgressRecord.swift
//  DrumBuddy
//
//  SwiftData model for tracking overall progress
//

import Foundation
import SwiftData

/// Persisted record of a practice session result
@Model
final class ProgressRecord {
    /// Unique identifier
    var id: UUID

    /// Pattern ID that was practiced
    var patternId: UUID

    /// Pattern name (for display without needing to look up pattern)
    var patternName: String

    /// Difficulty tier
    var difficultyRaw: Int

    /// Score achieved (0-100)
    var score: Int

    /// Star rating (0-3)
    var stars: Int

    /// BPM used
    var bpm: Int

    /// When this session occurred
    var timestamp: Date

    /// Number of matched hits
    var matchedHits: Int

    /// Number of expected hits
    var expectedHits: Int

    /// Average timing offset in ms
    var averageOffsetMs: Double

    var difficulty: DifficultyTier {
        get { DifficultyTier(rawValue: difficultyRaw) ?? .beginner }
        set { difficultyRaw = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        patternId: UUID,
        patternName: String,
        difficulty: DifficultyTier,
        score: Int,
        stars: Int,
        bpm: Int,
        timestamp: Date = Date(),
        matchedHits: Int,
        expectedHits: Int,
        averageOffsetMs: Double
    ) {
        self.id = id
        self.patternId = patternId
        self.patternName = patternName
        self.difficultyRaw = difficulty.rawValue
        self.score = score
        self.stars = stars
        self.bpm = bpm
        self.timestamp = timestamp
        self.matchedHits = matchedHits
        self.expectedHits = expectedHits
        self.averageOffsetMs = averageOffsetMs
    }

    /// Create from a session result
    convenience init(session: PracticeSession) {
        guard let result = session.result else {
            fatalError("Cannot create ProgressRecord from session without result")
        }

        self.init(
            patternId: session.pattern.id,
            patternName: session.pattern.name,
            difficulty: session.pattern.difficulty,
            score: result.overallScore,
            stars: result.starRating,
            bpm: session.bpm,
            matchedHits: result.matchedHits,
            expectedHits: result.expectedHits,
            averageOffsetMs: result.averageOffsetMs
        )
    }
}
