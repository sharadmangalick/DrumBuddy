//
//  HomeViewModel.swift
//  DrumBuddy
//
//  ViewModel for the home screen
//

import SwiftUI
import SwiftData

/// ViewModel for the home screen
@Observable
class HomeViewModel {
    /// Selected difficulty tier
    var selectedDifficulty: DifficultyTier = .beginner

    /// Generated patterns for each difficulty tier
    private var generatedPatterns: [DifficultyTier: [RhythmPattern]] = [:]

    /// Available patterns for selected difficulty (library + generated)
    var patterns: [RhythmPattern] {
        let libraryPatterns = PatternLibrary.patterns(for: selectedDifficulty)
        let generated = generatedPatterns[selectedDifficulty] ?? []
        return libraryPatterns + generated
    }

    /// Number of generated patterns for current difficulty
    var generatedCount: Int {
        generatedPatterns[selectedDifficulty]?.count ?? 0
    }

    /// Whether calibration sheet is shown
    var showCalibrationSheet = false

    /// Whether permission alert is shown
    var showPermissionAlert = false

    /// Generate a new random pattern for the current difficulty
    func generateNewPattern() {
        let newPattern = PatternGenerator.generate(for: selectedDifficulty)
        if generatedPatterns[selectedDifficulty] == nil {
            generatedPatterns[selectedDifficulty] = []
        }
        generatedPatterns[selectedDifficulty]?.append(newPattern)
    }

    /// Generate multiple patterns at once
    func generatePatterns(count: Int) {
        let newPatterns = PatternGenerator.generateBatch(count: count, for: selectedDifficulty)
        if generatedPatterns[selectedDifficulty] == nil {
            generatedPatterns[selectedDifficulty] = []
        }
        generatedPatterns[selectedDifficulty]?.append(contentsOf: newPatterns)
    }

    /// Clear all generated patterns for current difficulty
    func clearGeneratedPatterns() {
        generatedPatterns[selectedDifficulty] = []
    }

    /// Clear all generated patterns for all difficulties
    func clearAllGeneratedPatterns() {
        generatedPatterns = [:]
    }

    /// Get stats summary for a difficulty tier
    func statsSummary(for difficulty: DifficultyTier, stats: [PatternStats]) -> (completed: Int, total: Int) {
        let tierStats = stats.filter { $0.difficulty == difficulty }
        let totalPatterns = PatternLibrary.patterns(for: difficulty).count
        let completedPatterns = tierStats.filter { $0.isMastered }.count
        return (completedPatterns, totalPatterns)
    }

    /// Check and request microphone permission
    func checkMicrophonePermission() async -> Bool {
        if AudioPermissions.isAuthorized {
            return true
        }

        if AudioPermissions.isDenied {
            showPermissionAlert = true
            return false
        }

        return await AudioPermissions.requestPermission()
    }
}
