//
//  PracticeView.swift
//  DrumBuddy
//
//  Main practice screen for playing and recording patterns
//

import SwiftUI
import SwiftData

/// Main practice screen
struct PracticeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: PracticeViewModel
    let pattern: RhythmPattern
    let calibrationSettings: CalibrationSettings
    let onNextPattern: (() -> Void)?

    init(pattern: RhythmPattern, calibrationSettings: CalibrationSettings, onNextPattern: (() -> Void)? = nil) {
        self.pattern = pattern
        self.calibrationSettings = calibrationSettings
        self.onNextPattern = onNextPattern
        _viewModel = State(initialValue: PracticeViewModel(pattern: pattern, calibrationSettings: calibrationSettings))
    }

    var body: some View {
        ZStack {
            // Main content
            VStack(spacing: 20) {
                // Header
                headerView

                // Pattern info
                PatternVisualization(
                    pattern: pattern,
                    currentBeatIndex: viewModel.currentBeatIndex
                )

                // BPM control
                bpmControl

                Spacer()

                // State-specific content
                stateContent

                Spacer()

                // Action buttons
                actionButtons
            }
            .padding()

            // Countdown overlay
            if viewModel.state == .countingIn {
                CountdownView(value: viewModel.countdownValue)
            }

            // Results overlay
            if viewModel.state == .results, let result = viewModel.currentResult {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()

                ResultsView(
                    result: result,
                    pattern: pattern,
                    onTryAgain: {
                        viewModel.tryAgain()
                    },
                    onNextPattern: {
                        saveProgress()
                        if let next = onNextPattern {
                            next()
                        } else {
                            dismiss()
                        }
                    }
                )
                .background(Color(.systemBackground))
                .cornerRadius(24)
                .shadow(radius: 20)
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.state != .ready {
                    Button("Stop") {
                        viewModel.stop()
                    }
                }
            }
        }
        .onDisappear {
            viewModel.stop()
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        VStack(spacing: 4) {
            Text(pattern.emoji)
                .font(.system(size: 50))

            Text(pattern.name)
                .font(.title2)
                .fontWeight(.bold)

            HStack {
                Text(pattern.difficulty.emoji)
                Text(pattern.difficulty.displayName)
                    .foregroundColor(.secondary)
            }
            .font(.subheadline)
        }
    }

    private var bpmControl: some View {
        HStack(spacing: 20) {
            CircleButton(systemImage: "minus", color: .gray, size: 44) {
                viewModel.adjustBPM(by: -5)
            }
            .disabled(viewModel.state != .ready)

            VStack {
                Text("\(viewModel.bpm)")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                Text("BPM")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 80)

            CircleButton(systemImage: "plus", color: .gray, size: 44) {
                viewModel.adjustBPM(by: 5)
            }
            .disabled(viewModel.state != .ready)
        }
    }

    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.state {
        case .ready:
            Text("Tap Listen to hear the pattern, then Practice!")
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

        case .listening:
            VStack(spacing: 12) {
                Image(systemName: "speaker.wave.3.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
                    .symbolEffect(.pulse)
                Text("Listening...")
                    .font(.headline)
            }

        case .countingIn:
            EmptyView() // Handled by overlay

        case .recording:
            VStack(spacing: 16) {
                CircularLevelIndicator(level: viewModel.audioLevel, size: 120)

                HStack {
                    RecordingPulse()
                    Text("Recording...")
                        .font(.headline)
                }

                Text("Play the pattern on your drums!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

        case .processing:
            VStack(spacing: 12) {
                ProgressView()
                    .scaleEffect(1.5)
                Text("Checking your rhythm...")
                    .font(.headline)
            }

        case .results:
            EmptyView() // Handled by overlay
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 16) {
            if viewModel.state == .ready {
                HStack(spacing: 16) {
                    BigButton(
                        title: "Listen",
                        emoji: "👂",
                        color: .green,
                        action: viewModel.listenToPattern
                    )

                    BigButton(
                        title: "Practice",
                        emoji: "🥁",
                        color: .blue,
                        action: viewModel.startPractice
                    )
                }
            }
        }
    }

    // MARK: - Actions

    private func saveProgress() {
        if let record = viewModel.createProgressRecord() {
            modelContext.insert(record)

            // Update pattern stats
            updatePatternStats()
        }
    }

    private func updatePatternStats() {
        guard let result = viewModel.currentResult else { return }

        // Fetch or create pattern stats
        let patternId = pattern.id
        let descriptor = FetchDescriptor<PatternStats>(
            predicate: #Predicate { $0.patternId == patternId }
        )

        do {
            let existingStats = try modelContext.fetch(descriptor)

            if let stats = existingStats.first {
                stats.update(with: result)
            } else {
                let newStats = PatternStats(
                    patternId: pattern.id,
                    patternName: pattern.name,
                    difficulty: pattern.difficulty
                )
                newStats.update(with: result)
                modelContext.insert(newStats)
            }
        } catch {
            print("Failed to update pattern stats: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        PracticeView(
            pattern: PatternLibrary.beginnerPatterns[0],
            calibrationSettings: CalibrationSettings()
        )
    }
}
