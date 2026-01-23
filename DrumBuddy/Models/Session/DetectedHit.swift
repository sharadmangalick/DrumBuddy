//
//  DetectedHit.swift
//  DrumBuddy
//
//  Model representing a detected drum hit from microphone input
//

import Foundation

/// Represents a single detected hit from the microphone
struct DetectedHit: Identifiable, Codable, Hashable {
    let id: UUID

    /// Time of the hit relative to recording start (in seconds)
    let timestamp: TimeInterval

    /// Amplitude/intensity of the hit (0.0 to 1.0)
    let amplitude: Float

    /// Confidence level of the detection (0.0 to 1.0)
    let confidence: Float

    init(id: UUID = UUID(), timestamp: TimeInterval, amplitude: Float, confidence: Float = 1.0) {
        self.id = id
        self.timestamp = timestamp
        self.amplitude = amplitude
        self.confidence = confidence
    }
}

extension DetectedHit: Comparable {
    static func < (lhs: DetectedHit, rhs: DetectedHit) -> Bool {
        lhs.timestamp < rhs.timestamp
    }
}
