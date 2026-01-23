//
//  ProgressViewModel.swift
//  DrumBuddy
//
//  ViewModel for the progress screen
//

import SwiftUI
import SwiftData

/// ViewModel for the progress/stats screen
@Observable
class ProgressViewModel {
    /// Selected difficulty filter (nil = all)
    var selectedDifficulty: DifficultyTier?

    /// Sort order for records
    var sortOrder: SortOrder = .mostRecent

    enum SortOrder: String, CaseIterable {
        case mostRecent = "Most Recent"
        case highestScore = "Highest Score"
        case patternName = "Pattern Name"
    }

    /// Filter and sort progress records
    func filteredRecords(_ records: [ProgressRecord]) -> [ProgressRecord] {
        var filtered = records

        // Apply difficulty filter
        if let difficulty = selectedDifficulty {
            filtered = filtered.filter { $0.difficulty == difficulty }
        }

        // Apply sort
        switch sortOrder {
        case .mostRecent:
            filtered.sort { $0.timestamp > $1.timestamp }
        case .highestScore:
            filtered.sort { $0.score > $1.score }
        case .patternName:
            filtered.sort { $0.patternName < $1.patternName }
        }

        return filtered
    }

    /// Get statistics summary
    func getStatsSummary(from records: [ProgressRecord]) -> StatsSummary {
        guard !records.isEmpty else {
            return StatsSummary.empty
        }

        let totalAttempts = records.count
        let averageScore = Double(records.reduce(0) { $0 + $1.score }) / Double(totalAttempts)
        let threeStarCount = records.filter { $0.stars >= 3 }.count
        let uniquePatterns = Set(records.map { $0.patternId }).count

        // Calculate streak (consecutive days with practice)
        let streak = calculateStreak(from: records)

        return StatsSummary(
            totalAttempts: totalAttempts,
            averageScore: averageScore,
            threeStarCount: threeStarCount,
            uniquePatternsPlayed: uniquePatterns,
            currentStreak: streak
        )
    }

    /// Calculate practice streak
    private func calculateStreak(from records: [ProgressRecord]) -> Int {
        guard !records.isEmpty else { return 0 }

        let calendar = Calendar.current
        let sortedDates = records.map { calendar.startOfDay(for: $0.timestamp) }
            .sorted(by: >)

        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())

        for date in sortedDates {
            if date == currentDate {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else if date < currentDate {
                break
            }
        }

        return streak
    }

    /// Get stats for a specific pattern
    func getPatternStats(patternId: UUID, from stats: [PatternStats]) -> PatternStats? {
        stats.first { $0.patternId == patternId }
    }
}

/// Summary statistics
struct StatsSummary {
    let totalAttempts: Int
    let averageScore: Double
    let threeStarCount: Int
    let uniquePatternsPlayed: Int
    let currentStreak: Int

    static let empty = StatsSummary(
        totalAttempts: 0,
        averageScore: 0,
        threeStarCount: 0,
        uniquePatternsPlayed: 0,
        currentStreak: 0
    )
}
