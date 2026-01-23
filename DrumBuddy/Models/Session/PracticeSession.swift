//
//  PracticeSession.swift
//  DrumBuddy
//
//  Model representing a single practice attempt
//

import Foundation

/// Represents a single practice session/attempt
struct PracticeSession: Identifiable, Codable {
    let id: UUID

    /// The pattern being practiced
    let pattern: RhythmPattern

    /// BPM used for this attempt
    let bpm: Int

    /// When the session started
    let startTime: Date

    /// When recording ended
    let endTime: Date?

    /// Detected hits from the microphone
    var detectedHits: [DetectedHit]

    /// The result after scoring (nil until scored)
    var result: SessionResult?

    init(
        id: UUID = UUID(),
        pattern: RhythmPattern,
        bpm: Int? = nil,
        startTime: Date = Date(),
        endTime: Date? = nil,
        detectedHits: [DetectedHit] = [],
        result: SessionResult? = nil
    ) {
        self.id = id
        self.pattern = pattern
        self.bpm = bpm ?? pattern.suggestedBPM
        self.startTime = startTime
        self.endTime = endTime
        self.detectedHits = detectedHits
        self.result = result
    }

    /// Duration of the recording in seconds
    var recordingDuration: TimeInterval? {
        guard let endTime = endTime else { return nil }
        return endTime.timeIntervalSince(startTime)
    }
}
