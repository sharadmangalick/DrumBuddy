//
//  ToleranceCalculator.swift
//  DrumBuddy
//
//  Calculates timing tolerances based on difficulty
//

import Foundation

/// Calculates timing tolerances for scoring
struct ToleranceCalculator {

    /// Get tolerance in milliseconds for a difficulty tier
    static func tolerance(for difficulty: DifficultyTier) -> Double {
        return difficulty.timingToleranceMs
    }

    /// Get tolerance in seconds for a difficulty tier
    static func toleranceSeconds(for difficulty: DifficultyTier) -> TimeInterval {
        return difficulty.timingToleranceMs / 1000.0
    }

    /// Calculate a timing score based on offset
    /// - Parameters:
    ///   - offsetMs: Offset in milliseconds (positive = late, negative = early)
    ///   - toleranceMs: Maximum tolerance
    /// - Returns: Score from 0.0 to 1.0 (1.0 = perfect timing)
    static func timingScore(offsetMs: Double, toleranceMs: Double) -> Double {
        let absOffset = abs(offsetMs)

        // Perfect timing: full score
        if absOffset < 10 {
            return 1.0
        }

        // Linear falloff from 10ms to tolerance
        let range = toleranceMs - 10
        let position = absOffset - 10

        return max(0, 1.0 - (position / range))
    }
}
