//
//  PracticeViewModel.swift
//  DrumBuddy
//
//  ViewModel for the practice screen
//

import SwiftUI
import SwiftData

/// Practice session state
enum PracticeState: Equatable {
    case ready
    case listening
    case countingIn
    case recording
    case processing
    case results
}

/// ViewModel for the practice screen
@Observable
class PracticeViewModel {
    /// Current pattern being practiced
    var pattern: RhythmPattern

    /// Current BPM (can be adjusted)
    var bpm: Int

    /// Current state
    private(set) var state: PracticeState = .ready

    /// Audio coordinator
    let audioCoordinator = AudioEngineCoordinator()

    /// Feedback engine
    let feedbackEngine = FeedbackEngine()

    /// Calibration settings
    let calibrationSettings: CalibrationSettings

    /// Current session result (after scoring)
    private(set) var currentResult: SessionResult?

    /// Flash indicator when a hit is detected
    var hitFlash: Bool = false

    /// Running count of detected hits during recording
    private(set) var hitCount: Int = 0

    /// Current audio level (for visualization)
    var audioLevel: Float {
        audioCoordinator.audioLevel
    }

    /// Detected hits in current session
    var detectedHits: [DetectedHit] {
        audioCoordinator.currentHits
    }

    /// Countdown value (for display)
    private(set) var countdownValue: Int = 0

    /// Current beat index being played (for visualization)
    private(set) var currentBeatIndex: Int = -1

    /// Error message if something goes wrong
    var errorMessage: String?

    init(pattern: RhythmPattern, calibrationSettings: CalibrationSettings) {
        self.pattern = pattern
        self.bpm = pattern.suggestedBPM
        self.calibrationSettings = calibrationSettings

        setupCallbacks()
        applyCalibrationSettings()
    }

    private func setupCallbacks() {
        audioCoordinator.onRecordingComplete = { [weak self] hits in
            self?.processRecording(hits: hits)
        }

        audioCoordinator.playbackEngine.onBeatPlayed = { [weak self] index in
            self?.currentBeatIndex = index
        }

        audioCoordinator.onHitFeedback = { [weak self] in
            guard let self else { return }
            self.hitCount += 1
            self.hitFlash = true
            HapticFeedback.beatHit()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.hitFlash = false
            }
        }
    }

    private func applyCalibrationSettings() {
        let config = calibrationSettings.makeOnsetDetectorConfiguration()
        audioCoordinator.updateDetectionConfiguration(config)
        feedbackEngine.useTTS = calibrationSettings.ttsEnabled
    }

    /// Listen to the pattern (play without recording)
    func listenToPattern() {
        guard state == .ready else { return }

        state = .listening
        currentBeatIndex = -1

        do {
            try audioCoordinator.listenToPattern(pattern, atBPM: bpm)
        } catch {
            errorMessage = "Failed to play pattern: \(error.localizedDescription)"
            state = .ready
        }
    }

    /// Start practice attempt
    func startPractice() {
        guard state == .ready else { return }

        currentResult = nil
        currentBeatIndex = -1
        hitCount = 0
        applyCalibrationSettings()

        state = .countingIn
        countdownValue = 2

        do {
            try audioCoordinator.startPractice(pattern: pattern, atBPM: bpm)

            // Animate countdown
            let beatDuration = 60.0 / Double(bpm)
            DispatchQueue.main.asyncAfter(deadline: .now() + beatDuration) { [weak self] in
                self?.countdownValue = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + beatDuration * 2) { [weak self] in
                self?.countdownValue = 0
                self?.state = .recording
            }
        } catch {
            errorMessage = "Failed to start practice: \(error.localizedDescription)"
            state = .ready
        }
    }

    /// Process recording and calculate score
    private func processRecording(hits: [DetectedHit]) {
        state = .processing

        // Score the attempt
        let result = ScoringEngine.score(
            detectedHits: hits,
            pattern: pattern,
            bpm: bpm
        )

        currentResult = result
        state = .results

        // Deliver feedback
        feedbackEngine.deliverFeedback(for: result)

        // Haptic feedback
        HapticFeedback.stars(result.starRating)
    }

    /// Try the same pattern again
    func tryAgain() {
        state = .ready
        currentResult = nil
        currentBeatIndex = -1
    }

    /// Stop everything
    func stop() {
        audioCoordinator.stopAll()
        feedbackEngine.stopSpeaking()
        state = .ready
        currentBeatIndex = -1
    }

    /// Adjust BPM
    func adjustBPM(by delta: Int) {
        let newBPM = bpm + delta
        bpm = max(30, min(120, newBPM))
    }

    /// Create a ProgressRecord from the current result
    func createProgressRecord() -> ProgressRecord? {
        guard let result = currentResult else { return nil }

        return ProgressRecord(
            patternId: pattern.id,
            patternName: pattern.name,
            difficulty: pattern.difficulty,
            score: result.overallScore,
            stars: result.starRating,
            bpm: bpm,
            matchedHits: result.matchedHits,
            expectedHits: result.expectedHits,
            averageOffsetMs: result.averageOffsetMs
        )
    }
}
