//
//  PatternLibrary.swift
//  DrumBuddy
//
//  Hand-crafted rhythm patterns organized by difficulty
//

import Foundation

/// Library of hand-crafted rhythm patterns
struct PatternLibrary {

    /// All hand-crafted patterns
    static let allPatterns: [RhythmPattern] =
        beginnerPatterns + easyPeasyPatterns + gettingGoodPatterns + rockStarPatterns + drumHeroPatterns

    /// Get patterns for a specific difficulty
    static func patterns(for difficulty: DifficultyTier) -> [RhythmPattern] {
        switch difficulty {
        case .beginner: return beginnerPatterns
        case .easyPeasy: return easyPeasyPatterns
        case .gettingGood: return gettingGoodPatterns
        case .rockStar: return rockStarPatterns
        case .drumHero: return drumHeroPatterns
        }
    }

    // MARK: - Beginner Patterns (Quarter notes only, 50-60 BPM)

    static let beginnerPatterns: [RhythmPattern] = [
        // 4 steady quarter notes
        RhythmPattern(
            name: "Four Friends",
            emoji: "🐸",
            difficulty: .beginner,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 55
        ),

        // 3 quarter notes
        RhythmPattern(
            name: "Three Bears",
            emoji: "🐻",
            difficulty: .beginner,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 2)
            ],
            suggestedBPM: 50
        ),

        // Beats 1 and 3
        RhythmPattern(
            name: "Heartbeat",
            emoji: "💓",
            difficulty: .beginner,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 2)
            ],
            suggestedBPM: 55
        ),

        // Beats 1, 2, 3
        RhythmPattern(
            name: "Clap Clap Clap",
            emoji: "👏",
            difficulty: .beginner,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 2)
            ],
            suggestedBPM: 52
        ),

        // All four beats with a rest
        RhythmPattern(
            name: "March Along",
            emoji: "🚶",
            difficulty: .beginner,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 60
        ),

        // Two beats - simplest
        RhythmPattern(
            name: "Knock Knock",
            emoji: "🚪",
            difficulty: .beginner,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1)
            ],
            suggestedBPM: 50
        ),

        // Beats 1 and 4
        RhythmPattern(
            name: "Bookends",
            emoji: "📚",
            difficulty: .beginner,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 55
        ),

        // Just beat 1
        RhythmPattern(
            name: "One Big Boom",
            emoji: "💥",
            difficulty: .beginner,
            beats: [
                Beat(positionInBeats: 0)
            ],
            suggestedBPM: 50
        ),

        // Beats 2, 3, 4
        RhythmPattern(
            name: "Ready Set Go",
            emoji: "🏃",
            difficulty: .beginner,
            beats: [
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 55
        ),

        // Beats 1, 3, 4
        RhythmPattern(
            name: "Skip a Beat",
            emoji: "⏭️",
            difficulty: .beginner,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 58
        )
    ]

    // MARK: - Easy Peasy Patterns (Quarter + half notes, 55-65 BPM)

    static let easyPeasyPatterns: [RhythmPattern] = [
        // Half note + two quarters
        RhythmPattern(
            name: "Slow Start",
            emoji: "🐢",
            difficulty: .easyPeasy,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 58
        ),

        // Two quarters + half
        RhythmPattern(
            name: "Quick Quick Slow",
            emoji: "🦊",
            difficulty: .easyPeasy,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 2)
            ],
            suggestedBPM: 60
        ),

        // Quarter, half, quarter
        RhythmPattern(
            name: "Sandwich Beat",
            emoji: "🥪",
            difficulty: .easyPeasy,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 58
        ),

        // Two half notes
        RhythmPattern(
            name: "Elephant Walk",
            emoji: "🐘",
            difficulty: .easyPeasy,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 2)
            ],
            suggestedBPM: 62
        ),

        // Dotted pattern feel
        RhythmPattern(
            name: "Bunny Hop",
            emoji: "🐰",
            difficulty: .easyPeasy,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 65
        ),

        // Just beats 1 and 2
        RhythmPattern(
            name: "Bumblebee",
            emoji: "🐝",
            difficulty: .easyPeasy,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1)
            ],
            suggestedBPM: 60
        ),

        // Beats 1, 2, 4
        RhythmPattern(
            name: "Caterpillar",
            emoji: "🐛",
            difficulty: .easyPeasy,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 58
        ),

        // Beats 2 and 4 (backbeat)
        RhythmPattern(
            name: "Snare Shake",
            emoji: "🎵",
            difficulty: .easyPeasy,
            beats: [
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 62
        ),

        // All four
        RhythmPattern(
            name: "Tick Tock",
            emoji: "⏰",
            difficulty: .easyPeasy,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 58
        ),

        // Beats 1, 3, 4
        RhythmPattern(
            name: "Frog Jump",
            emoji: "🐸",
            difficulty: .easyPeasy,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 60
        )
    ]

    // MARK: - Getting Good Patterns (Quarter + eighth notes, 60-75 BPM)

    static let gettingGoodPatterns: [RhythmPattern] = [
        // Eighth notes on 1
        RhythmPattern(
            name: "Double Tap",
            emoji: "✌️",
            difficulty: .gettingGood,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 65
        ),

        // Running eighths
        RhythmPattern(
            name: "Pitter Patter",
            emoji: "🌧️",
            difficulty: .gettingGood,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.5)
            ],
            suggestedBPM: 62
        ),

        // Offbeat eighths
        RhythmPattern(
            name: "Skip Along",
            emoji: "🦘",
            difficulty: .gettingGood,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 68
        ),

        // Mixed pattern
        RhythmPattern(
            name: "Monkey Dance",
            emoji: "🐵",
            difficulty: .gettingGood,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.5),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 60
        ),

        // Gallop rhythm
        RhythmPattern(
            name: "Horse Gallop",
            emoji: "🐴",
            difficulty: .gettingGood,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.5),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 70
        ),

        // Quick doubles
        RhythmPattern(
            name: "Ping Pong",
            emoji: "🏓",
            difficulty: .gettingGood,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.5)
            ],
            suggestedBPM: 65
        ),

        // Steady eighths
        RhythmPattern(
            name: "Train Chug",
            emoji: "🚂",
            difficulty: .gettingGood,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.5)
            ],
            suggestedBPM: 62
        ),

        // Swing feel
        RhythmPattern(
            name: "Jazz Cat",
            emoji: "🐱",
            difficulty: .gettingGood,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 68
        ),

        // Syncopated
        RhythmPattern(
            name: "Skateboard",
            emoji: "🛹",
            difficulty: .gettingGood,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 70
        ),

        // Off-beat heavy
        RhythmPattern(
            name: "Reggae Vibe",
            emoji: "🌴",
            difficulty: .gettingGood,
            beats: [
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 2.5),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 65
        )
    ]

    // MARK: - Rock Star Patterns (All + off-beats, 65-80 BPM)

    static let rockStarPatterns: [RhythmPattern] = [
        // Syncopated rock beat
        RhythmPattern(
            name: "Rock Out",
            emoji: "🎸",
            difficulty: .rockStar,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 72
        ),

        // Funky pattern
        RhythmPattern(
            name: "Funky Chicken",
            emoji: "🐔",
            difficulty: .rockStar,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 68
        ),

        // Complex syncopation
        RhythmPattern(
            name: "Ninja Stealth",
            emoji: "🥷",
            difficulty: .rockStar,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 2.5),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 75
        ),

        // Driving rhythm
        RhythmPattern(
            name: "Race Car",
            emoji: "🏎️",
            difficulty: .rockStar,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.5),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 70
        ),

        // Groove pattern
        RhythmPattern(
            name: "Disco Ball",
            emoji: "🪩",
            difficulty: .rockStar,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 2.5),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 78
        ),

        // Heavy syncopation
        RhythmPattern(
            name: "Breakdance",
            emoji: "🕺",
            difficulty: .rockStar,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 2.5),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 72
        ),

        // Metal-style
        RhythmPattern(
            name: "Thunder Storm",
            emoji: "⛈️",
            difficulty: .rockStar,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.5),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 75
        ),

        // Punk energy
        RhythmPattern(
            name: "Skatepunk",
            emoji: "🤘",
            difficulty: .rockStar,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 80
        ),

        // Hip hop groove
        RhythmPattern(
            name: "Boom Bap",
            emoji: "🎧",
            difficulty: .rockStar,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 70
        ),

        // Latin feel
        RhythmPattern(
            name: "Salsa Fire",
            emoji: "🌶️",
            difficulty: .rockStar,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.5),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 76
        )
    ]

    // MARK: - Drum Hero Patterns (All + triplets, 70-90 BPM)

    static let drumHeroPatterns: [RhythmPattern] = [
        // Triplet feel
        RhythmPattern(
            name: "Triple Threat",
            emoji: "🔱",
            difficulty: .drumHero,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.33),
                Beat(positionInBeats: 0.67),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.33),
                Beat(positionInBeats: 2.67),
                Beat(positionInBeats: 3)
            ],
            suggestedBPM: 72
        ),

        // Mixed triplets and eighths
        RhythmPattern(
            name: "Dragon Fire",
            emoji: "🐉",
            difficulty: .drumHero,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.33),
                Beat(positionInBeats: 1.67),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 75
        ),

        // Complex groove
        RhythmPattern(
            name: "Wizard Spell",
            emoji: "🧙",
            difficulty: .drumHero,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.33),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.67),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 78
        ),

        // Shuffle feel
        RhythmPattern(
            name: "Superhero",
            emoji: "🦸",
            difficulty: .drumHero,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.67),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.67),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.67),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.67)
            ],
            suggestedBPM: 80
        ),

        // Ultimate challenge
        RhythmPattern(
            name: "Champion",
            emoji: "🏆",
            difficulty: .drumHero,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.33),
                Beat(positionInBeats: 0.67),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.33),
                Beat(positionInBeats: 2.67),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 85
        ),

        // Jazz complexity
        RhythmPattern(
            name: "Jazz Master",
            emoji: "🎷",
            difficulty: .drumHero,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.67),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.33),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.5),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.67)
            ],
            suggestedBPM: 78
        ),

        // Afrobeat inspired
        RhythmPattern(
            name: "African Sun",
            emoji: "☀️",
            difficulty: .drumHero,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.33),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.5),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.67),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 82
        ),

        // Polyrhythm feel
        RhythmPattern(
            name: "Mind Bender",
            emoji: "🧠",
            difficulty: .drumHero,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 0.67),
                Beat(positionInBeats: 1.33),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.33),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 75
        ),

        // Speed challenge
        RhythmPattern(
            name: "Speed Demon",
            emoji: "👹",
            difficulty: .drumHero,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.33),
                Beat(positionInBeats: 0.67),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.33),
                Beat(positionInBeats: 1.67),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.5),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 88
        ),

        // Final boss
        RhythmPattern(
            name: "Legendary",
            emoji: "⚡",
            difficulty: .drumHero,
            beats: [
                Beat(positionInBeats: 0),
                Beat(positionInBeats: 0.33),
                Beat(positionInBeats: 0.5),
                Beat(positionInBeats: 1),
                Beat(positionInBeats: 1.33),
                Beat(positionInBeats: 1.67),
                Beat(positionInBeats: 2),
                Beat(positionInBeats: 2.5),
                Beat(positionInBeats: 2.67),
                Beat(positionInBeats: 3),
                Beat(positionInBeats: 3.5)
            ],
            suggestedBPM: 90
        )
    ]
}
