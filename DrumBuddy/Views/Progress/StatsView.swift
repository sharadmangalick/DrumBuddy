//
//  StatsView.swift
//  DrumBuddy
//
//  Shows practice history and statistics
//

import SwiftUI
import SwiftData

/// Progress and statistics screen
struct StatsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ProgressRecord.timestamp, order: .reverse) private var records: [ProgressRecord]
    @Query private var patternStats: [PatternStats]

    @State var viewModel: ProgressViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Summary stats
                statsSummarySection

                // Filter controls
                filterSection

                // History
                historySection
            }
            .padding()
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Subviews

    private var statsSummarySection: some View {
        let summary = viewModel.getStatsSummary(from: records)

        return VStack(spacing: 16) {
            // Main stats row
            HStack(spacing: 16) {
                SummaryStatCard(
                    value: "\(summary.totalAttempts)",
                    label: "Total Attempts",
                    icon: "flame.fill",
                    color: .orange
                )

                SummaryStatCard(
                    value: "\(Int(summary.averageScore))",
                    label: "Avg Score",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .blue
                )
            }

            HStack(spacing: 16) {
                SummaryStatCard(
                    value: "\(summary.threeStarCount)",
                    label: "3-Star Wins",
                    icon: "star.fill",
                    color: .yellow
                )

                SummaryStatCard(
                    value: "\(summary.currentStreak)",
                    label: "Day Streak",
                    icon: "calendar",
                    color: .green
                )
            }
        }
    }

    private var filterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Difficulty filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(
                        title: "All",
                        isSelected: viewModel.selectedDifficulty == nil,
                        action: { viewModel.selectedDifficulty = nil }
                    )

                    ForEach(DifficultyTier.allCases) { tier in
                        FilterChip(
                            title: tier.emoji + " " + tier.displayName,
                            isSelected: viewModel.selectedDifficulty == tier,
                            action: { viewModel.selectedDifficulty = tier }
                        )
                    }
                }
            }

            // Sort picker
            Picker("Sort", selection: $viewModel.sortOrder) {
                ForEach(ProgressViewModel.SortOrder.allCases, id: \.self) { order in
                    Text(order.rawValue).tag(order)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("History")
                .font(.title2)
                .fontWeight(.bold)

            if records.isEmpty {
                emptyState
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredRecords(records)) { record in
                        HistoryRow(record: record)
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Text("🎵")
                .font(.system(size: 60))

            Text("No practice sessions yet!")
                .font(.headline)

            Text("Go practice some patterns to see your progress here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

/// Summary stat card
struct SummaryStatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }

            Text(value)
                .font(.title)
                .fontWeight(.bold)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

/// Filter chip button
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
        .buttonStyle(.plain)
    }
}

/// Single history row
struct HistoryRow: View {
    let record: ProgressRecord

    var body: some View {
        HStack(spacing: 12) {
            // Difficulty emoji
            Text(record.difficulty.emoji)
                .font(.title2)

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(record.patternName)
                    .font(.headline)

                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Score and stars
            VStack(alignment: .trailing, spacing: 4) {
                StarRating(rating: record.stars, size: 14)

                Text("\(record.score) pts")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: record.timestamp, relativeTo: Date())
    }
}

#Preview {
    NavigationStack {
        StatsView(viewModel: ProgressViewModel())
    }
    .modelContainer(for: [ProgressRecord.self, PatternStats.self], inMemory: true)
}
