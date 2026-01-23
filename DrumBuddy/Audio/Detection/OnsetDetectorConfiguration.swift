//
//  OnsetDetectorConfiguration.swift
//  DrumBuddy
//
//  Configuration parameters for onset detection
//

import Foundation

/// Configuration for onset detection algorithms
struct OnsetDetectorConfiguration {
    /// Minimum time between detected hits (in milliseconds)
    /// Prevents double-triggering on single hits
    var refractoryPeriodMs: Double = 100

    /// Threshold for onset detection (0.0 to 1.0)
    /// Higher = less sensitive, lower = more sensitive
    var threshold: Float = 0.3

    /// Smoothing factor for envelope follower (0.0 to 1.0)
    /// Higher = smoother signal, more latency
    var smoothingFactor: Float = 0.9

    /// Noise floor level - signals below this are ignored
    var noiseFloor: Float = 0.01

    /// Attack time for envelope follower (in samples)
    var attackSamples: Int = 10

    /// Release time for envelope follower (in samples)
    var releaseSamples: Int = 100

    /// Microphone gain multiplier
    var micGainMultiplier: Float = 1.0

    /// Sample rate (set by audio engine)
    var sampleRate: Double = 44100

    /// Refractory period in samples (computed)
    var refractoryPeriodSamples: Int {
        Int((refractoryPeriodMs / 1000.0) * sampleRate)
    }

    /// Default configuration
    static let `default` = OnsetDetectorConfiguration()

    /// High sensitivity configuration (for quiet drums or far mic)
    static let highSensitivity = OnsetDetectorConfiguration(
        threshold: 0.15,
        noiseFloor: 0.005,
        micGainMultiplier: 2.0
    )

    /// Low sensitivity configuration (for loud drums or close mic)
    static let lowSensitivity = OnsetDetectorConfiguration(
        threshold: 0.5,
        noiseFloor: 0.02,
        micGainMultiplier: 0.7
    )
}
