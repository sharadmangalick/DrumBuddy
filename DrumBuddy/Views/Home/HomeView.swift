//
//  HomeView.swift
//  DrumBuddy
//
//  Main home screen with pattern selection
//

import SwiftUI
import SwiftData

/// Main home screen
struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var patternStats: [PatternStats]

    @State private var viewModel = HomeViewModel()
    @State private var calibrationSettings = CalibrationSettings()
    @State private var selectedPattern: RhythmPattern?
    @State private var showDebugView = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Title with hidden calibration
                    titleSection

                    // Difficulty selector
                    DifficultySelector(selectedDifficulty: $viewModel.selectedDifficulty)

                    // Patterns for selected difficulty
                    patternsSection

                    // Quick stats
                    if !patternStats.isEmpty {
                        quickStatsSection
                    }
                }
                .padding(.vertical)
            }
            .navigationDestination(item: $selectedPattern) { pattern in
                PracticeView(
                    pattern: pattern,
                    calibrationSettings: calibrationSettings,
                    onNextPattern: {
                        selectNextPattern(after: pattern)
                    }
                )
            }
            .sheet(isPresented: $viewModel.showCalibrationSheet) {
                CalibrationView(settings: calibrationSettings)
            }
            .sheet(isPresented: $showDebugView) {
                NavigationStack {
                    DebugView()
                }
            }
            .alert("Microphone Access Needed", isPresented: $viewModel.showPermissionAlert) {
                Button("OK") {}
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            } message: {
                Text("DrumBuddy needs microphone access to hear your drumming. Please enable it in Settings.")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        StatsView(viewModel: ProgressViewModel())
                    } label: {
                        Image(systemName: "chart.bar.fill")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showDebugView = true
                    } label: {
                        Image(systemName: "waveform")
                    }
                }
            }
        }
    }

    // MARK: - Subviews

    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("🥁")
                .font(.system(size: 60))

            Text("DrumBuddy")
                .font(.largeTitle)
                .fontWeight(.bold)
                .onLongPressGesture(minimumDuration: 2.0) {
                    HapticFeedback.success()
                    viewModel.showCalibrationSheet = true
                }

            Text("Let's practice some rhythms!")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top)
    }

    private var patternsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Patterns")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Text("\(completedCount)/\(viewModel.patterns.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            LazyVStack(spacing: 12) {
                ForEach(viewModel.patterns) { pattern in
                    PatternRow(
                        pattern: pattern,
                        stats: statsFor(pattern),
                        action: {
                            Task {
                                if await viewModel.checkMicrophonePermission() {
                                    selectedPattern = pattern
                                }
                            }
                        }
                    )
                }

                // Generate new pattern button
                generatePatternButton
            }
            .padding(.horizontal)
        }
    }

    private var generatePatternButton: some View {
        Button {
            HapticFeedback.light()
            viewModel.generateNewPattern()
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 50, height: 50)

                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.blue)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Generate New Pattern")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text("Create a random \(viewModel.selectedDifficulty.displayName) pattern")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundColor(.yellow)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
            )
        }
        .buttonStyle(.plain)
    }

    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Progress")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

            HStack(spacing: 16) {
                QuickStatCard(
                    value: "\(totalStars)",
                    label: "Stars",
                    emoji: "⭐"
                )

                QuickStatCard(
                    value: "\(totalAttempts)",
                    label: "Attempts",
                    emoji: "🎯"
                )

                QuickStatCard(
                    value: "\(masteredPatterns)",
                    label: "Mastered",
                    emoji: "🏆"
                )
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Helpers

    private var completedCount: Int {
        patternStats.filter { stats in
            viewModel.patterns.contains { $0.id == stats.patternId } && stats.isMastered
        }.count
    }

    private var totalStars: Int {
        patternStats.reduce(0) { $0 + $1.bestStars }
    }

    private var totalAttempts: Int {
        patternStats.reduce(0) { $0 + $1.totalAttempts }
    }

    private var masteredPatterns: Int {
        patternStats.filter { $0.isMastered }.count
    }

    private func statsFor(_ pattern: RhythmPattern) -> PatternStats? {
        patternStats.first { $0.patternId == pattern.id }
    }

    private func selectNextPattern(after current: RhythmPattern) {
        let patterns = viewModel.patterns
        if let currentIndex = patterns.firstIndex(where: { $0.id == current.id }) {
            let nextIndex = (currentIndex + 1) % patterns.count
            selectedPattern = patterns[nextIndex]
        }
    }
}

/// Row displaying a single pattern
struct PatternRow: View {
    let pattern: RhythmPattern
    let stats: PatternStats?
    let action: () -> Void

    var body: some View {
        Button(action: {
            HapticFeedback.light()
            action()
        }) {
            HStack(spacing: 16) {
                // Emoji
                Text(pattern.emoji)
                    .font(.system(size: 36))
                    .frame(width: 50)

                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(pattern.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text("\(pattern.hits.count) beats • \(pattern.suggestedBPM) BPM")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Stars or play indicator
                if let stats = stats, stats.bestStars > 0 {
                    StarRating(rating: stats.bestStars, size: 16)
                } else {
                    Image(systemName: "play.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}

/// Quick stat display card
struct QuickStatCard: View {
    let value: String
    let label: String
    let emoji: String

    var body: some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.title)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [ProgressRecord.self, PatternStats.self], inMemory: true)
}
