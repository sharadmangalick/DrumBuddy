//
//  EnvelopeFollower.swift
//  DrumBuddy
//
//  Envelope follower for smooth amplitude tracking
//

import Foundation

/// Follows the amplitude envelope of an audio signal
/// Uses fast attack and slow release for percussive transient detection
class EnvelopeFollower {
    /// Current envelope value
    private(set) var envelope: Float = 0

    /// Attack coefficient (0.0 to 1.0)
    private var attackCoeff: Float

    /// Release coefficient (0.0 to 1.0)
    private var releaseCoeff: Float

    init(attackSamples: Int = 10, releaseSamples: Int = 100) {
        // Convert sample counts to coefficients
        // Coefficient = 1 - e^(-1/samples)
        self.attackCoeff = 1.0 - exp(-1.0 / Float(max(1, attackSamples)))
        self.releaseCoeff = 1.0 - exp(-1.0 / Float(max(1, releaseSamples)))
    }

    /// Update attack and release times
    func updateTimes(attackSamples: Int, releaseSamples: Int) {
        self.attackCoeff = 1.0 - exp(-1.0 / Float(max(1, attackSamples)))
        self.releaseCoeff = 1.0 - exp(-1.0 / Float(max(1, releaseSamples)))
    }

    /// Process a single sample and return the envelope value
    func process(_ sample: Float) -> Float {
        let rectified = abs(sample)

        if rectified > envelope {
            // Attack phase - signal is rising
            envelope += attackCoeff * (rectified - envelope)
        } else {
            // Release phase - signal is falling
            envelope += releaseCoeff * (rectified - envelope)
        }

        return envelope
    }

    /// Process an array of samples and return the peak envelope value
    func processBatch(_ samples: [Float]) -> Float {
        var peakEnvelope: Float = 0

        for sample in samples {
            let env = process(sample)
            if env > peakEnvelope {
                peakEnvelope = env
            }
        }

        return peakEnvelope
    }

    /// Reset the envelope to zero
    func reset() {
        envelope = 0
    }
}
