//
//  CalibrationSettings.swift
//  DrumBuddy
//
//  User-adjustable calibration settings stored in UserDefaults
//

import SwiftUI

/// Calibration settings stored in UserDefaults
@Observable
class CalibrationSettings {
    /// Onset detection threshold (0.1 to 0.8)
    var onsetThreshold: Double {
        didSet {
            UserDefaults.standard.set(onsetThreshold, forKey: "onsetThreshold")
        }
    }

    /// Timing tolerance override in ms (0 = use difficulty default)
    var timingToleranceOverrideMs: Double {
        didSet {
            UserDefaults.standard.set(timingToleranceOverrideMs, forKey: "timingToleranceOverrideMs")
        }
    }

    /// Microphone gain multiplier (0.5 to 3.0)
    var micGainMultiplier: Double {
        didSet {
            UserDefaults.standard.set(micGainMultiplier, forKey: "micGainMultiplier")
        }
    }

    /// Noise floor (0.005 to 0.05)
    var noiseFloor: Double {
        didSet {
            UserDefaults.standard.set(noiseFloor, forKey: "noiseFloor")
        }
    }

    /// Refractory period in ms (50 to 200)
    var refractoryPeriodMs: Double {
        didSet {
            UserDefaults.standard.set(refractoryPeriodMs, forKey: "refractoryPeriodMs")
        }
    }

    /// Whether TTS is enabled
    var ttsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(ttsEnabled, forKey: "ttsEnabled")
        }
    }

    /// Default values
    static let defaultOnsetThreshold: Double = 0.3
    static let defaultTimingToleranceOverrideMs: Double = 0
    static let defaultMicGainMultiplier: Double = 1.0
    static let defaultNoiseFloor: Double = 0.01
    static let defaultRefractoryPeriodMs: Double = 100
    static let defaultTTSEnabled: Bool = true

    init() {
        // Load from UserDefaults or use defaults
        self.onsetThreshold = UserDefaults.standard.object(forKey: "onsetThreshold") as? Double
            ?? Self.defaultOnsetThreshold

        self.timingToleranceOverrideMs = UserDefaults.standard.object(forKey: "timingToleranceOverrideMs") as? Double
            ?? Self.defaultTimingToleranceOverrideMs

        self.micGainMultiplier = UserDefaults.standard.object(forKey: "micGainMultiplier") as? Double
            ?? Self.defaultMicGainMultiplier

        self.noiseFloor = UserDefaults.standard.object(forKey: "noiseFloor") as? Double
            ?? Self.defaultNoiseFloor

        self.refractoryPeriodMs = UserDefaults.standard.object(forKey: "refractoryPeriodMs") as? Double
            ?? Self.defaultRefractoryPeriodMs

        self.ttsEnabled = UserDefaults.standard.object(forKey: "ttsEnabled") as? Bool
            ?? Self.defaultTTSEnabled
    }

    /// Reset all settings to defaults
    func resetToDefaults() {
        onsetThreshold = Self.defaultOnsetThreshold
        timingToleranceOverrideMs = Self.defaultTimingToleranceOverrideMs
        micGainMultiplier = Self.defaultMicGainMultiplier
        noiseFloor = Self.defaultNoiseFloor
        refractoryPeriodMs = Self.defaultRefractoryPeriodMs
        ttsEnabled = Self.defaultTTSEnabled
    }

    /// Create OnsetDetectorConfiguration from current settings
    func makeOnsetDetectorConfiguration() -> OnsetDetectorConfiguration {
        var config = OnsetDetectorConfiguration()
        config.threshold = Float(onsetThreshold)
        config.micGainMultiplier = Float(micGainMultiplier)
        config.noiseFloor = Float(noiseFloor)
        config.refractoryPeriodMs = refractoryPeriodMs
        return config
    }

    /// Get timing tolerance (override or difficulty default)
    func timingTolerance(for difficulty: DifficultyTier) -> Double {
        if timingToleranceOverrideMs > 0 {
            return timingToleranceOverrideMs
        }
        return difficulty.timingToleranceMs
    }
}
