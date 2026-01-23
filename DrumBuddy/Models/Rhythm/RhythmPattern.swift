//
//  RhythmPattern.swift
//  DrumBuddy
//
//  Model representing a complete rhythm pattern
//

import Foundation

/// A complete rhythm pattern that can be played and practiced
struct RhythmPattern: Identifiable, Codable, Hashable {
    let id: UUID

    /// Display name for the pattern
    let name: String

    /// Emoji icon for the pattern
    let emoji: String

    /// Difficulty tier
    let difficulty: DifficultyTier

    /// The beats that make up this pattern (sorted by position)
    let beats: [Beat]

    /// Suggested BPM for this pattern
    let suggestedBPM: Int

    /// Whether this is a hand-crafted pattern (vs generated)
    let isHandCrafted: Bool

    /// Time signature numerator (beats per measure)
    let timeSignatureTop: Int

    /// Time signature denominator (note value that gets one beat)
    let timeSignatureBottom: Int

    init(
        id: UUID = UUID(),
        name: String,
        emoji: String,
        difficulty: DifficultyTier,
        beats: [Beat],
        suggestedBPM: Int? = nil,
        isHandCrafted: Bool = true,
        timeSignatureTop: Int = 4,
        timeSignatureBottom: Int = 4
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.difficulty = difficulty
        self.beats = beats.sorted()
        self.suggestedBPM = suggestedBPM ?? difficulty.suggestedBPM
        self.isHandCrafted = isHandCrafted
        self.timeSignatureTop = timeSignatureTop
        self.timeSignatureBottom = timeSignatureBottom
    }

    /// Only the beats that are hits (not rests)
    var hits: [Beat] {
        beats.filter { !$0.isRest }
    }

    /// Total duration in beats
    var durationInBeats: Double {
        guard let lastBeat = beats.last else { return 0 }
        // Add one beat after the last hit for the pattern to feel complete
        return lastBeat.positionInBeats + 1.0
    }

    /// Total duration in seconds at the suggested BPM
    var durationInSeconds: TimeInterval {
        durationInSeconds(atBPM: suggestedBPM)
    }

    /// Total duration in seconds at a given BPM
    func durationInSeconds(atBPM bpm: Int) -> TimeInterval {
        return (durationInBeats * 60.0) / Double(bpm)
    }

    /// Number of measures in the pattern
    var measureCount: Int {
        Int(ceil(durationInBeats / Double(timeSignatureTop)))
    }

    /// Get hit times in seconds at a given BPM
    func hitTimes(atBPM bpm: Int) -> [TimeInterval] {
        hits.map { $0.timeInSeconds(atBPM: bpm) }
    }
}
