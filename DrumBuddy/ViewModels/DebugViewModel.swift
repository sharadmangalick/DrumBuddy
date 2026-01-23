//
//  DebugViewModel.swift
//  DrumBuddy
//
//  ViewModel for the debug screen
//

import SwiftUI

/// ViewModel for the debug/testing screen
@Observable
class DebugViewModel {
    /// Audio coordinator for testing
    let audioCoordinator = AudioEngineCoordinator()

    /// Current audio level
    var audioLevel: Float = 0

    /// Whether we're currently monitoring
    private(set) var isMonitoring = false

    /// Detected hits during monitoring
    private(set) var detectedHits: [DetectedHit] = []

    /// Configuration for testing
    var testConfiguration = OnsetDetectorConfiguration()

    /// Last N audio levels for waveform
    private(set) var audioLevelHistory: [Float] = []
    private let historySize = 100

    init() {
        setupCallbacks()
    }

    private func setupCallbacks() {
        audioCoordinator.micEngine.onHitDetected = { [weak self] hit in
            self?.detectedHits.append(hit)
        }

        audioCoordinator.micEngine.onLevelUpdate = { [weak self] level in
            self?.audioLevel = level
            self?.addToHistory(level)
        }
    }

    private func addToHistory(_ level: Float) {
        audioLevelHistory.append(level)
        if audioLevelHistory.count > historySize {
            audioLevelHistory.removeFirst()
        }
    }

    /// Start monitoring microphone
    func startMonitoring() {
        guard !isMonitoring else { return }

        detectedHits = []
        audioLevelHistory = []

        // Apply test configuration
        audioCoordinator.updateDetectionConfiguration(testConfiguration)

        do {
            try audioCoordinator.micEngine.configureAudioSession()
            try audioCoordinator.micEngine.startRecording()
            isMonitoring = true
        } catch {
            print("Failed to start monitoring: \(error)")
        }
    }

    /// Stop monitoring
    func stopMonitoring() {
        guard isMonitoring else { return }

        _ = audioCoordinator.micEngine.stopRecording()
        isMonitoring = false
    }

    /// Clear detected hits
    func clearHits() {
        detectedHits = []
    }

    /// Test a pattern
    func testPattern(_ pattern: RhythmPattern, atBPM bpm: Int) {
        do {
            try audioCoordinator.listenToPattern(pattern, atBPM: bpm)
        } catch {
            print("Failed to play pattern: \(error)")
        }
    }

    /// Apply configuration changes
    func applyConfiguration() {
        audioCoordinator.updateDetectionConfiguration(testConfiguration)
    }
}
