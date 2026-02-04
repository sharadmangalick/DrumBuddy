//
//  AudioEngineCoordinator.swift
//  DrumBuddy
//
//  Coordinates playback and recording audio engines
//

import AVFoundation

/// Coordinates the audio playback and microphone capture engines
@Observable
class AudioEngineCoordinator {
    /// Playback engine for patterns
    let playbackEngine: AudioPlaybackEngine

    /// Microphone capture engine
    let micEngine: MicCaptureEngine

    /// Current state
    enum State: Equatable {
        case idle
        case playingPattern
        case countingIn
        case recording
        case processing
    }

    private(set) var state: State = .idle

    /// Current audio level (for visualization)
    private(set) var audioLevel: Float = 0

    /// Detected hits from current recording
    private(set) var currentHits: [DetectedHit] = []

    /// Callback when recording completes
    var onRecordingComplete: (([DetectedHit]) -> Void)?

    /// Recording timer
    private var recordingTimer: Timer?

    init() {
        self.playbackEngine = AudioPlaybackEngine()
        self.micEngine = MicCaptureEngine()

        setupCallbacks()
    }

    private func setupCallbacks() {
        micEngine.onHitDetected = { [weak self] hit in
            self?.currentHits.append(hit)
        }

        micEngine.onLevelUpdate = { [weak self] level in
            self?.audioLevel = level
        }

        playbackEngine.onPlaybackComplete = { [weak self] in
            // Pattern finished, now handled by practice flow
        }
    }

    /// Configure audio session for the app
    func configureAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetooth])
        try session.setActive(true)
    }

    /// Play a pattern (listen mode - no recording)
    func listenToPattern(_ pattern: RhythmPattern, atBPM bpm: Int) throws {
        guard state == .idle else { return }

        try configurePlaybackSession()
        try playbackEngine.start()

        state = .playingPattern
        playbackEngine.playPattern(pattern, atBPM: bpm, includeCountIn: false)

        playbackEngine.onPlaybackComplete = { [weak self] in
            self?.state = .idle
        }
    }

    /// Start a practice attempt: count-in → play pattern → record
    func startPractice(pattern: RhythmPattern, atBPM bpm: Int) throws {
        guard state == .idle else { return }

        currentHits = []

        // Configure for playback first
        try configurePlaybackSession()
        try playbackEngine.start()

        // Calculate timing
        let countInDuration = 120.0 / Double(bpm) // 2 beats
        let patternDuration = pattern.durationInSeconds(atBPM: bpm)
        let recordingDuration = patternDuration + 0.5 // Add buffer

        // Start count-in
        state = .countingIn
        playbackEngine.playPattern(pattern, atBPM: bpm, includeCountIn: true)

        // Schedule recording to start after count-in
        DispatchQueue.main.asyncAfter(deadline: .now() + countInDuration) { [weak self] in
            self?.startRecording(duration: recordingDuration)
        }
    }

    private func startRecording(duration: TimeInterval) {
        guard state == .countingIn else { return }

        state = .recording

        do {
            // Switch to recording mode
            try configureRecordingSession()
            try micEngine.startRecording()

            // Schedule end of recording
            recordingTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
                self?.stopRecording()
            }
        } catch {
            print("Failed to start recording: \(error)")
            state = .idle
        }
    }

    /// Stop recording and process results
    func stopRecording() {
        guard state == .recording else { return }

        recordingTimer?.invalidate()
        recordingTimer = nil

        state = .processing
        let hits = micEngine.stopRecording()
        currentHits = hits

        // Notify completion
        DispatchQueue.main.async { [weak self] in
            self?.state = .idle
            self?.onRecordingComplete?(hits)
        }
    }

    /// Stop everything
    func stopAll() {
        recordingTimer?.invalidate()
        recordingTimer = nil

        playbackEngine.stopPlayback()
        _ = micEngine.stopRecording()
        state = .idle
    }

    /// Configure audio session for playback and recording
    /// Using playAndRecord from the start to avoid session switching issues
    private func configurePlaybackSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetooth])
        try session.setActive(true)
    }

    /// Configure audio session for recording (same as playback now)
    private func configureRecordingSession() throws {
        // Audio session already configured for playAndRecord
        // Just ensure it's still active
        let session = AVAudioSession.sharedInstance()
        try session.setActive(true)
    }

    /// Update onset detection configuration
    func updateDetectionConfiguration(_ config: OnsetDetectorConfiguration) {
        micEngine.updateConfiguration(config)
    }
}
