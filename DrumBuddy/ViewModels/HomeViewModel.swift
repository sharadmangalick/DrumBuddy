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

    /// Available patterns for selected difficulty
    var patterns: [RhythmPattern] {
        PatternLibrary.patterns(for: selectedDifficulty)
    }

    /// Whether calibration sheet is shown
    var showCalibrationSheet = false

    /// Whether permission alert is shown
    var showPermissionAlert = false

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
