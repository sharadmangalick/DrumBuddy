//
//  PatternGenerator.swift
//  DrumBuddy
//
//  Procedurally generates unlimited rhythm patterns for each difficulty tier
//

import Foundation

/// Generates random rhythm patterns based on difficulty tier rules
class PatternGenerator {

    /// Generate a random pattern for a given difficulty tier
    static func generate(for tier: DifficultyTier) -> RhythmPattern {
        var beats: [Beat] = []
        var currentBeat: Double = 0
        let maxBeats = Double(tier.measures * 4) // 4 beats per measure

        // Always start with a hit on beat 1
        beats.append(Beat(positionInBeats: 0, isRest: false))
        currentBeat = tier.allowedSteps.randomElement() ?? 1.0

        // Build the pattern
        while currentBeat < maxBeats - 0.5 {
            // Decide whether to place a hit (70% chance) or skip
            let placeHit = Double.random(in: 0...1) < 0.7

            if placeHit {
                beats.append(Beat(positionInBeats: currentBeat, isRest: false))
            }

            // Advance by an allowed step
            let step = tier.allowedSteps.randomElement() ?? 1.0
            currentBeat += step
        }

        // Ensure we have at least minBeats hits
        while beats.count < tier.minBeats {
            let possiblePositions = stride(from: 0.0, to: maxBeats, by: 0.5)
                .filter { pos in !beats.contains { $0.positionInBeats == pos } }

            if let newPos = possiblePositions.randomElement() {
                beats.append(Beat(positionInBeats: newPos, isRest: false))
            } else {
                break
            }
        }

        // Trim if we have too many
        while beats.count > tier.maxBeats {
            if beats.count > 1 {
                beats.removeLast()
            }
        }

        return RhythmPattern(
            name: generateFunName(),
            emoji: generateEmoji(for: tier),
            difficulty: tier,
            beats: beats.sorted(),
            suggestedBPM: Int.random(in: tier.bpmRange),
            isHandCrafted: false
        )
    }

    /// Generate a batch of patterns
    static func generateBatch(count: Int, for tier: DifficultyTier) -> [RhythmPattern] {
        (0..<count).map { _ in generate(for: tier) }
    }

    /// Generate a fun name for the pattern
    private static func generateFunName() -> String {
        let adjectives = [
            "Happy", "Bouncy", "Silly", "Funky", "Cool", "Wild", "Groovy",
            "Jazzy", "Snappy", "Zippy", "Peppy", "Zesty", "Wacky", "Dizzy",
            "Speedy", "Lucky", "Sunny", "Starry", "Sparkly", "Mighty"
        ]

        let nouns = [
            "Frog", "Monkey", "Robot", "Dancer", "Drummer", "Star", "Beat",
            "Dragon", "Tiger", "Puppy", "Kitten", "Bunny", "Panda", "Penguin",
            "Unicorn", "Rocket", "Rainbow", "Thunder", "Lightning", "Wave"
        ]

        return "\(adjectives.randomElement()!) \(nouns.randomElement()!)"
    }

    /// Generate an appropriate emoji for the tier
    private static func generateEmoji(for tier: DifficultyTier) -> String {
        let emojis: [DifficultyTier: [String]] = [
            .beginner: ["🐸", "🐻", "🐶", "🐱", "🐰", "🐷", "🐮", "🦆"],
            .easyPeasy: ["🌟", "⭐", "🌈", "🎈", "🎀", "🌸", "🦋", "🌺"],
            .gettingGood: ["🔥", "💪", "🎯", "🚀", "⚡", "🌊", "🎪", "🎭"],
            .rockStar: ["🎸", "🎤", "🎹", "🥁", "🎷", "🎺", "🪘", "🎻"],
            .drumHero: ["👑", "🏆", "💎", "🔱", "⚔️", "🛡️", "🦁", "🐉"]
        ]

        return emojis[tier]?.randomElement() ?? "🎵"
    }
}
