//
//  OnsetDetector.swift
//  DrumBuddy
//
//  Protocol for onset detection - enables future ML implementation swap
//

import AVFoundation

/// Protocol for audio onset detection
/// Implementations detect when a percussive hit occurs in audio
protocol OnsetDetector {
    /// Configuration parameters
    var configuration: OnsetDetectorConfiguration { get set }

    /// Process an audio buffer and detect any onset
    /// - Parameters:
    ///   - buffer: Audio buffer to analyze
    ///   - timestamp: Time relative to recording start
    /// - Returns: DetectedHit if an onset was found, nil otherwise
    func detectOnset(in buffer: AVAudioPCMBuffer, at timestamp: TimeInterval) -> DetectedHit?

    /// Reset internal state (call when starting a new recording)
    func reset()

    /// Current signal level (for visualization)
    var currentLevel: Float { get }
}
