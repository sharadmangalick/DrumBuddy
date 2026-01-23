//
//  PeakPicker.swift
//  DrumBuddy
//
//  Peak detection for finding onset points in an envelope signal
//

import Foundation

/// Detects peaks in an envelope signal for onset detection
class PeakPicker {
    /// Threshold for peak detection
    var threshold: Float

    /// Noise floor - signals below this are ignored
    var noiseFloor: Float

    /// Previous envelope value
    private var previousValue: Float = 0

    /// Whether we're looking for a peak (vs in refractory period)
    private var isArmed: Bool = true

    /// Samples since last peak
    private var samplesSinceLastPeak: Int = 0

    /// Refractory period in samples
    var refractoryPeriodSamples: Int

    init(threshold: Float = 0.3, noiseFloor: Float = 0.01, refractoryPeriodSamples: Int = 4410) {
        self.threshold = threshold
        self.noiseFloor = noiseFloor
        self.refractoryPeriodSamples = refractoryPeriodSamples
    }

    /// Check if a value represents a peak
    /// - Parameters:
    ///   - currentValue: Current envelope value
    ///   - sampleCount: Number of samples in the current buffer
    /// - Returns: True if a peak was detected
    func isPeak(currentValue: Float, sampleCount: Int) -> Bool {
        defer {
            previousValue = currentValue
            samplesSinceLastPeak += sampleCount
        }

        // Update refractory state
        if !isArmed && samplesSinceLastPeak >= refractoryPeriodSamples {
            isArmed = true
        }

        guard isArmed else { return false }

        // Check if above noise floor
        guard currentValue > noiseFloor else { return false }

        // Check if above threshold
        guard currentValue > threshold else { return false }

        // Check if this is a peak (was rising, now falling or stable)
        // For percussive sounds, we detect when signal exceeds threshold while rising
        let isRising = currentValue > previousValue * 1.1 // 10% increase
        let isAboveThreshold = currentValue > threshold

        if isAboveThreshold && (isRising || previousValue < noiseFloor) {
            // Peak detected!
            isArmed = false
            samplesSinceLastPeak = 0
            return true
        }

        return false
    }

    /// Reset the picker state
    func reset() {
        previousValue = 0
        isArmed = true
        samplesSinceLastPeak = 0
    }

    /// Update configuration
    func updateConfiguration(threshold: Float, noiseFloor: Float, refractoryPeriodSamples: Int) {
        self.threshold = threshold
        self.noiseFloor = noiseFloor
        self.refractoryPeriodSamples = refractoryPeriodSamples
    }
}
