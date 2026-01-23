//
//  Beat.swift
//  DrumBuddy
//
//  Core model representing a single beat in a rhythm pattern
//

import Foundation

/// Represents a single beat position in a rhythm pattern
struct Beat: Identifiable, Codable, Hashable {
    let id: UUID

    /// Position in beats (0 = first beat, 0.5 = eighth note after first beat, etc.)
    let positionInBeats: Double

    /// Whether this beat is a rest (silence) or a hit
    let isRest: Bool

    /// Optional accent level (1.0 = normal, > 1.0 = accented, < 1.0 = ghost note)
    let accent: Double

    init(id: UUID = UUID(), positionInBeats: Double, isRest: Bool = false, accent: Double = 1.0) {
        self.id = id
        self.positionInBeats = positionInBeats
        self.isRest = isRest
        self.accent = accent
    }

    /// Convert beat position to time in seconds at a given BPM
    func timeInSeconds(atBPM bpm: Int) -> TimeInterval {
        return (positionInBeats * 60.0) / Double(bpm)
    }

    /// Convert beat position to sample position at a given BPM and sample rate
    func samplePosition(atBPM bpm: Int, sampleRate: Double) -> Int64 {
        let timeInSeconds = self.timeInSeconds(atBPM: bpm)
        return Int64(timeInSeconds * sampleRate)
    }
}

extension Beat: Comparable {
    static func < (lhs: Beat, rhs: Beat) -> Bool {
        lhs.positionInBeats < rhs.positionInBeats
    }
}
