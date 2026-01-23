//
//  DebugView.swift
//  DrumBuddy
//
//  Debug screen for testing onset detection and tuning parameters
//

import SwiftUI

/// Debug/testing screen for onset detection
struct DebugView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = DebugViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Waveform display
                waveformSection

                // Detection parameters
                parametersSection

                // Detected hits
                hitsSection

                // Test patterns
                testSection
            }
            .padding()
        }
        .navigationTitle("Debug")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") { dismiss() }
            }
        }
        .onDisappear {
            viewModel.stopMonitoring()
        }
    }

    // MARK: - Subviews

    private var waveformSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Audio Input")
                    .font(.headline)

                Spacer()

                // Monitor toggle
                Button(viewModel.isMonitoring ? "Stop" : "Start") {
                    if viewModel.isMonitoring {
                        viewModel.stopMonitoring()
                    } else {
                        viewModel.startMonitoring()
                    }
                }
                .buttonStyle(.borderedProminent)
            }

            // Waveform
            WaveformView(
                levels: viewModel.audioLevelHistory,
                threshold: Float(viewModel.testConfiguration.threshold)
            )
            .frame(height: 100)

            // Current level
            HStack {
                Text("Level:")
                PeakLevelMeter(level: viewModel.audioLevel, peakLevel: viewModel.audioLevel)
            }
        }
    }

    private var parametersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Detection Parameters")
                .font(.headline)

            // Threshold
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Threshold")
                    Spacer()
                    Text(String(format: "%.2f", viewModel.testConfiguration.threshold))
                        .foregroundColor(.secondary)
                }
                Slider(
                    value: Binding(
                        get: { Double(viewModel.testConfiguration.threshold) },
                        set: { viewModel.testConfiguration.threshold = Float($0) }
                    ),
                    in: 0.05...0.8
                )
            }

            // Noise floor
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Noise Floor")
                    Spacer()
                    Text(String(format: "%.3f", viewModel.testConfiguration.noiseFloor))
                        .foregroundColor(.secondary)
                }
                Slider(
                    value: Binding(
                        get: { Double(viewModel.testConfiguration.noiseFloor) },
                        set: { viewModel.testConfiguration.noiseFloor = Float($0) }
                    ),
                    in: 0.001...0.05
                )
            }

            // Refractory period
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Refractory Period")
                    Spacer()
                    Text("\(Int(viewModel.testConfiguration.refractoryPeriodMs))ms")
                        .foregroundColor(.secondary)
                }
                Slider(
                    value: $viewModel.testConfiguration.refractoryPeriodMs,
                    in: 50...200
                )
            }

            // Mic gain
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Mic Gain")
                    Spacer()
                    Text(String(format: "%.1fx", viewModel.testConfiguration.micGainMultiplier))
                        .foregroundColor(.secondary)
                }
                Slider(
                    value: Binding(
                        get: { Double(viewModel.testConfiguration.micGainMultiplier) },
                        set: { viewModel.testConfiguration.micGainMultiplier = Float($0) }
                    ),
                    in: 0.5...3.0
                )
            }

            Button("Apply Changes") {
                viewModel.applyConfiguration()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var hitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Detected Hits")
                    .font(.headline)

                Spacer()

                Text("\(viewModel.detectedHits.count)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)

                Button("Clear") {
                    viewModel.clearHits()
                }
                .buttonStyle(.bordered)
            }

            if !viewModel.detectedHits.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.detectedHits.suffix(20)) { hit in
                            VStack(spacing: 4) {
                                Text(String(format: "%.2fs", hit.timestamp))
                                    .font(.caption)
                                Text(String(format: "%.2f", hit.amplitude))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(8)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(8)
                        }
                    }
                }
            } else {
                Text("No hits detected yet. Start monitoring and tap your drums!")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var testSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Test Patterns")
                .font(.headline)

            HStack(spacing: 12) {
                ForEach(PatternLibrary.beginnerPatterns.prefix(3)) { pattern in
                    Button {
                        viewModel.testPattern(pattern, atBPM: pattern.suggestedBPM)
                    } label: {
                        VStack {
                            Text(pattern.emoji)
                                .font(.title)
                            Text(pattern.name)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DebugView()
    }
}
