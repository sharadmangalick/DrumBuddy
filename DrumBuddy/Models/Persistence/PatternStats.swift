//
//  PatternStats.swift
//  DrumBuddy
//
//  SwiftData model for tracking per-pattern statistics
//

import Foundation
import SwiftData

/// Aggregated statistics for a specific pattern
@Model
final class PatternStats {
    /// Pattern ID
    var patternId: UUID

    /// Pattern name
    var patternName: String

    /// Difficulty tier
    var difficultyRaw: Int

    /// Total number of attempts
    var totalAttempts: Int

    /// Best score achieved
    var bestScore: Int

    /// Best star rating achieved
    var bestStars: Int

    /// Average score across all attempts
    var averageScore: Double

    /// Most recent attempt date
    var lastAttemptDate: Date

    /// First attempt date
    var firstAttemptDate: Date

    /// Number of 3-star completions
    var threeStarCount: Int

    var difficulty: DifficultyTier {
        get { DifficultyTier(rawValue: difficultyRaw) ?? .beginner }
        set { difficultyRaw = newValue.rawValue }
    }

    init(
        patternId: UUID,
        patternName: String,
        difficulty: DifficultyTier,
        totalAttempts: Int = 0,
        bestScore: Int = 0,
        bestStars: Int = 0,
        averageScore: Double = 0,
        lastAttemptDate: Date = Date(),
        firstAttemptDate: Date = Date(),
        threeStarCount: Int = 0
    ) {
        self.patternId = patternId
        self.patternName = patternName
        self.difficultyRaw = difficulty.rawValue
        self.totalAttempts = totalAttempts
        self.bestScore = bestScore
        self.bestStars = bestStars
        self.averageScore = averageScore
        self.lastAttemptDate = lastAttemptDate
        self.firstAttemptDate = firstAttemptDate
        self.threeStarCount = threeStarCount
    }

    /// Update stats with a new result
    func update(with result: SessionResult) {
        totalAttempts += 1
        lastAttemptDate = Date()

        if result.overallScore > bestScore {
            bestScore = result.overallScore
        }

        if result.starRating > bestStars {
            bestStars = result.starRating
        }

        if result.starRating == 3 {
            threeStarCount += 1
        }

        // Update running average
        let totalScore = averageScore * Double(totalAttempts - 1) + Double(result.overallScore)
        averageScore = totalScore / Double(totalAttempts)
    }

    /// Whether this pattern has been mastered (3 stars achieved)
    var isMastered: Bool {
        bestStars >= 3
    }
}
