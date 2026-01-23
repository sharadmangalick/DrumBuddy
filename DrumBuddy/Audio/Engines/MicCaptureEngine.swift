//
//  MicCaptureEngine.swift
//  DrumBuddy
//
//  Handles microphone input capture and onset detection
//

import AVFoundation

/// Engine for capturing microphone input and detecting drum hits
class MicCaptureEngine {
    private let audioEngine = AVAudioEngine()
    private let inputNode: AVAudioInputNode

    /// Onset detector for finding drum hits
    var onsetDetector: OnsetDetector

    /// Buffer size for input tap (smaller = lower latency, but more CPU)
    private let bufferSize: AVAudioFrameCount = 512  // ~11.6ms at 44.1kHz

    /// Recording state
    private(set) var isRecording = false

    /// Recording start time
    private var recordingStartTime: Date?

    /// Detected hits during recording
    private(set) var detectedHits: [DetectedHit] = []

    /// Callback when a hit is detected
    var onHitDetected: ((DetectedHit) -> Void)?

    /// Callback for audio level updates (for visualization)
    var onLevelUpdate: ((Float) -> Void)?

    /// Sample rate
    let sampleRate: Double

    init(onsetDetector: OnsetDetector = EnergyOnsetDetector()) {
        self.onsetDetector = onsetDetector
        self.inputNode = audioEngine.inputNode
        self.sampleRate = inputNode.inputFormat(forBus: 0).sampleRate

        // Update detector with actual sample rate
        self.onsetDetector.configuration.sampleRate = sampleRate
    }

    /// Configure audio session for recording
    func configureAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetooth])
        try session.setActive(true)
    }

    /// Start recording and detecting hits
    func startRecording() throws {
        guard !isRecording else { return }

        // Reset state
        detectedHits = []
        onsetDetector.reset()
        recordingStartTime = Date()

        // Install tap on input
        let format = inputNode.inputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: format) { [weak self] buffer, time in
            self?.processAudioBuffer(buffer, at: time)
        }

        // Start engine
        try audioEngine.start()
        isRecording = true
    }

    /// Stop recording
    func stopRecording() -> [DetectedHit] {
        guard isRecording else { return detectedHits }

        inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        isRecording = false

        return detectedHits
    }

    /// Process incoming audio buffer
    private func processAudioBuffer(_ buffer: AVAudioPCMBuffer, at time: AVAudioTime) {
        guard let startTime = recordingStartTime else { return }

        // Calculate timestamp relative to recording start
        let timestamp = Date().timeIntervalSince(startTime)

        // Update level for visualization
        DispatchQueue.main.async { [weak self] in
            self?.onLevelUpdate?(self?.onsetDetector.currentLevel ?? 0)
        }

        // Detect onset
        if let hit = onsetDetector.detectOnset(in: buffer, at: timestamp) {
            detectedHits.append(hit)

            DispatchQueue.main.async { [weak self] in
                self?.onHitDetected?(hit)
            }
        }
    }

    /// Current audio level (for visualization)
    var currentLevel: Float {
        onsetDetector.currentLevel
    }

    /// Update onset detector configuration
    func updateConfiguration(_ config: OnsetDetectorConfiguration) {
        var newConfig = config
        newConfig.sampleRate = sampleRate
        onsetDetector.configuration = newConfig
    }
}
