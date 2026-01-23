//
//  DifficultyTier.swift
//  DrumBuddy
//
//  Difficulty levels for rhythm patterns
//

import Foundation

/// Difficulty tiers for rhythm patterns, designed for a 6-year-old learning progression
enum DifficultyTier: Int, CaseIterable, Codable, Identifiable {
    case beginner = 0
    case easyPeasy = 1
    case gettingGood = 2
    case rockStar = 3
    case drumHero = 4

    var id: Int { rawValue }

    /// Display name for the tier
    var displayName: String {
        switch self {
        case .beginner: return "Beginner"
        case .easyPeasy: return "Easy Peasy"
        case .gettingGood: return "Getting Good"
        case .rockStar: return "Rock Star"
        case .drumHero: return "Drum Hero"
        }
    }

    /// Emoji representing the tier
    var emoji: String {
        switch self {
        case .beginner: return "🐣"
        case .easyPeasy: return "🌟"
        case .gettingGood: return "🔥"
        case .rockStar: return "🎸"
        case .drumHero: return "👑"
        }
    }

    /// Color name for the tier (for UI)
    var colorName: String {
        switch self {
        case .beginner: return "green"
        case .easyPeasy: return "blue"
        case .gettingGood: return "orange"
        case .rockStar: return "purple"
        case .drumHero: return "red"
        }
    }

    /// Timing tolerance in milliseconds for scoring
    var timingToleranceMs: Double {
        switch self {
        case .beginner: return 150
        case .easyPeasy: return 130
        case .gettingGood: return 110
        case .rockStar: return 90
        case .drumHero: return 70
        }
    }

    /// BPM range for patterns at this tier
    var bpmRange: ClosedRange<Int> {
        switch self {
        case .beginner: return 50...60
        case .easyPeasy: return 55...65
        case .gettingGood: return 60...75
        case .rockStar: return 65...80
        case .drumHero: return 70...90
        }
    }

    /// Suggested BPM (middle of range)
    var suggestedBPM: Int {
        (bpmRange.lowerBound + bpmRange.upperBound) / 2
    }

    /// Allowed note value steps (in beats) for pattern generation
    var allowedSteps: [Double] {
        switch self {
        case .beginner:
            return [1.0] // Quarter notes only
        case .easyPeasy:
            return [1.0, 2.0] // Quarter + half notes
        case .gettingGood:
            return [0.5, 1.0] // Eighth + quarter notes
        case .rockStar:
            return [0.5, 1.0, 1.5] // Eighth, quarter, dotted quarter
        case .drumHero:
            return [0.33, 0.5, 1.0] // Triplets, eighth, quarter
        }
    }

    /// Maximum number of beats in a pattern
    var maxBeats: Int {
        switch self {
        case .beginner: return 8
        case .easyPeasy: return 8
        case .gettingGood: return 10
        case .rockStar: return 12
        case .drumHero: return 16
        }
    }

    /// Minimum number of beats in a pattern
    var minBeats: Int {
        switch self {
        case .beginner: return 4
        case .easyPeasy: return 4
        case .gettingGood: return 6
        case .rockStar: return 8
        case .drumHero: return 10
        }
    }

    /// Number of measures for patterns at this tier
    var measures: Int {
        switch self {
        case .beginner, .easyPeasy: return 1
        case .gettingGood, .rockStar: return 2
        case .drumHero: return 2
        }
    }
}
