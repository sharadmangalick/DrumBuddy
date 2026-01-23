//
//  EnergyOnsetDetector.swift
//  DrumBuddy
//
//  Energy-based onset detection implementation
//

import AVFoundation

/// MVP onset detector using energy-based detection
/// Analyzes audio energy to detect percussive hits
class EnergyOnsetDetector: OnsetDetector {
    var configuration: OnsetDetectorConfiguration {
        didSet {
            updateInternalConfiguration()
        }
    }

    /// Current signal level for visualization
    private(set) var currentLevel: Float = 0

    /// Envelope follower for amplitude tracking
    private let envelopeFollower: EnvelopeFollower

    /// Peak picker for detecting onsets
    private let peakPicker: PeakPicker

    init(configuration: OnsetDetectorConfiguration = .default) {
        self.configuration = configuration
        self.envelopeFollower = EnvelopeFollower(
            attackSamples: configuration.attackSamples,
            releaseSamples: configuration.releaseSamples
        )
        self.peakPicker = PeakPicker(
            threshold: configuration.threshold,
            noiseFloor: configuration.noiseFloor,
            refractoryPeriodSamples: configuration.refractoryPeriodSamples
        )
    }

    func detectOnset(in buffer: AVAudioPCMBuffer, at timestamp: TimeInterval) -> DetectedHit? {
        guard let channelData = buffer.floatChannelData else { return nil }

        let frameCount = Int(buffer.frameLength)
        let samples = Array(UnsafeBufferPointer(start: channelData[0], count: frameCount))

        // Apply mic gain
        let gainedSamples = samples.map { $0 * configuration.micGainMultiplier }

        // Calculate RMS energy
        let rms = calculateRMS(gainedSamples)
        currentLevel = rms

        // Process through envelope follower
        let envelope = envelopeFollower.processBatch(gainedSamples)

        // Check for peak
        if peakPicker.isPeak(currentValue: envelope, sampleCount: frameCount) {
            return DetectedHit(
                timestamp: timestamp,
                amplitude: envelope,
                confidence: min(envelope / configuration.threshold, 1.0)
            )
        }

        return nil
    }

    func reset() {
        envelopeFollower.reset()
        peakPicker.reset()
        currentLevel = 0
    }

    /// Calculate RMS (Root Mean Square) of samples
    private func calculateRMS(_ samples: [Float]) -> Float {
        guard !samples.isEmpty else { return 0 }

        let sumOfSquares = samples.reduce(0) { $0 + $1 * $1 }
        return sqrt(sumOfSquares / Float(samples.count))
    }

    /// Update internal components when configuration changes
    private func updateInternalConfiguration() {
        envelopeFollower.updateTimes(
            attackSamples: configuration.attackSamples,
            releaseSamples: configuration.releaseSamples
        )
        peakPicker.updateConfiguration(
            threshold: configuration.threshold,
            noiseFloor: configuration.noiseFloor,
            refractoryPeriodSamples: configuration.refractoryPeriodSamples
        )
    }
}
