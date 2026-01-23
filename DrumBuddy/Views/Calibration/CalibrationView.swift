//
//  CalibrationView.swift
//  DrumBuddy
//
//  Hidden calibration screen for parents to tune detection parameters
//

import SwiftUI

/// Calibration settings view (accessed via long-press on title)
struct CalibrationView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var settings: CalibrationSettings

    @State private var audioCoordinator = AudioEngineCoordinator()
    @State private var isTestingMic = false
    @State private var testAudioLevel: Float = 0

    var body: some View {
        NavigationStack {
            Form {
                // Detection settings
                Section("Detection Sensitivity") {
                    // Onset threshold
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Onset Threshold")
                            Spacer()
                            Text(String(format: "%.2f", settings.onsetThreshold))
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $settings.onsetThreshold, in: 0.1...0.8)
                        Text("Lower = more sensitive, Higher = less sensitive")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    // Mic gain
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Microphone Gain")
                            Spacer()
                            Text(String(format: "%.1fx", settings.micGainMultiplier))
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $settings.micGainMultiplier, in: 0.5...3.0)
                        Text("Increase for quiet drums or far microphone")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    // Noise floor
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Noise Floor")
                            Spacer()
                            Text(String(format: "%.3f", settings.noiseFloor))
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $settings.noiseFloor, in: 0.005...0.05)
                        Text("Increase in noisy environments")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                // Timing settings
                Section("Timing") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Refractory Period")
                            Spacer()
                            Text("\(Int(settings.refractoryPeriodMs))ms")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $settings.refractoryPeriodMs, in: 50...200)
                        Text("Minimum time between detected hits")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Timing Tolerance Override")
                            Spacer()
                            Text(settings.timingToleranceOverrideMs > 0 ? "\(Int(settings.timingToleranceOverrideMs))ms" : "Off")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $settings.timingToleranceOverrideMs, in: 0...200)
                        Text("0 = use difficulty-based tolerance")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                // Other settings
                Section("Other") {
                    Toggle("Text-to-Speech Feedback", isOn: $settings.ttsEnabled)
                }

                // Test section
                Section("Test") {
                    VStack(spacing: 16) {
                        HStack {
                            Text("Microphone Level")
                            Spacer()
                            CircularLevelIndicator(level: testAudioLevel, size: 60)
                        }

                        Button(isTestingMic ? "Stop Test" : "Test Microphone") {
                            toggleMicTest()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }

                // Reset
                Section {
                    Button("Reset to Defaults", role: .destructive) {
                        settings.resetToDefaults()
                    }
                }
            }
            .navigationTitle("Calibration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .onDisappear {
                stopMicTest()
            }
        }
    }

    // MARK: - Mic Test

    private func toggleMicTest() {
        if isTestingMic {
            stopMicTest()
        } else {
            startMicTest()
        }
    }

    private func startMicTest() {
        isTestingMic = true

        // Apply current settings
        audioCoordinator.updateDetectionConfiguration(settings.makeOnsetDetectorConfiguration())

        // Setup level callback
        audioCoordinator.micEngine.onLevelUpdate = { level in
            testAudioLevel = level
        }

        do {
            try audioCoordinator.micEngine.configureAudioSession()
            try audioCoordinator.micEngine.startRecording()
        } catch {
            print("Failed to start mic test: \(error)")
            isTestingMic = false
        }
    }

    private func stopMicTest() {
        if isTestingMic {
            _ = audioCoordinator.micEngine.stopRecording()
            isTestingMic = false
            testAudioLevel = 0
        }
    }
}

#Preview {
    CalibrationView(settings: CalibrationSettings())
}
