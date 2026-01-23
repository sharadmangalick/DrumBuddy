//
//  AudioPlaybackEngine.swift
//  DrumBuddy
//
//  Handles playback of rhythm patterns using synthesized sounds
//

import AVFoundation

/// Engine for playing back rhythm patterns with precise timing
class AudioPlaybackEngine {
    private let audioEngine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()

    /// Sample rate
    let sampleRate: Double = 44100

    /// Pre-generated sound buffers
    private var clapBuffer: AVAudioPCMBuffer!
    private var clickBuffer: AVAudioPCMBuffer!
    private var accentClickBuffer: AVAudioPCMBuffer!

    /// Playback state
    private(set) var isPlaying = false

    /// Callback for each beat played (for visual sync)
    var onBeatPlayed: ((Int) -> Void)?

    /// Callback when pattern playback completes
    var onPlaybackComplete: (() -> Void)?

    init() {
        setupAudioEngine()
        generateSoundBuffers()
    }

    private func setupAudioEngine() {
        // Attach player node to engine
        audioEngine.attach(playerNode)

        // Connect player to main mixer
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: format)
    }

    private func generateSoundBuffers() {
        clapBuffer = SoundGenerator.generateClap(sampleRate: sampleRate)
        clickBuffer = SoundGenerator.generateClick(sampleRate: sampleRate)
        accentClickBuffer = SoundGenerator.generateAccentClick(sampleRate: sampleRate)
    }

    /// Start the audio engine
    func start() throws {
        guard !audioEngine.isRunning else { return }

        try audioEngine.start()
    }

    /// Stop the audio engine
    func stop() {
        playerNode.stop()
        audioEngine.stop()
        isPlaying = false
    }

    /// Play a rhythm pattern
    /// - Parameters:
    ///   - pattern: The pattern to play
    ///   - bpm: Tempo in beats per minute
    ///   - includeCountIn: Whether to play a 2-beat count-in first
    func playPattern(_ pattern: RhythmPattern, atBPM bpm: Int, includeCountIn: Bool = false) {
        guard !isPlaying else { return }

        isPlaying = true

        // Calculate timing
        let secondsPerBeat = 60.0 / Double(bpm)
        let samplesPerBeat = secondsPerBeat * sampleRate

        // Schedule sounds
        var scheduledTime: AVAudioFramePosition = 0

        // Get the current time
        guard let nodeTime = playerNode.lastRenderTime,
              let playerTime = playerNode.playerTime(forNodeTime: nodeTime) else {
            // If not playing yet, start from zero
            schedulePatternSounds(pattern, bpm: bpm, startingAt: 0, includeCountIn: includeCountIn)
            return
        }

        schedulePatternSounds(pattern, bpm: bpm, startingAt: playerTime.sampleTime, includeCountIn: includeCountIn)
    }

    private func schedulePatternSounds(_ pattern: RhythmPattern, bpm: Int, startingAt startSample: AVAudioFramePosition, includeCountIn: Bool) {
        let secondsPerBeat = 60.0 / Double(bpm)
        let samplesPerBeat = Int64(secondsPerBeat * sampleRate)

        var currentSample = startSample + Int64(sampleRate * 0.1) // Small delay to start

        // Count-in
        if includeCountIn {
            for i in 0..<2 {
                let time = AVAudioTime(sampleTime: currentSample, atRate: sampleRate)
                playerNode.scheduleBuffer(clickBuffer, at: time, options: [], completionHandler: nil)
                currentSample += samplesPerBeat
            }
        }

        let patternStartSample = currentSample

        // Schedule each hit in the pattern
        for (index, beat) in pattern.hits.enumerated() {
            let beatSample = patternStartSample + Int64(beat.positionInBeats * Double(samplesPerBeat))
            let time = AVAudioTime(sampleTime: beatSample, atRate: sampleRate)

            let buffer = beat.accent > 1.0 ? accentClickBuffer! : clapBuffer!

            playerNode.scheduleBuffer(buffer, at: time, options: []) { [weak self] in
                DispatchQueue.main.async {
                    self?.onBeatPlayed?(index)
                }
            }
        }

        // Schedule completion callback
        let endSample = patternStartSample + Int64(pattern.durationInBeats * Double(samplesPerBeat))
        let endTime = AVAudioTime(sampleTime: endSample, atRate: sampleRate)

        // Create a tiny silent buffer for the completion callback
        let silentFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        let silentBuffer = AVAudioPCMBuffer(pcmFormat: silentFormat, frameCapacity: 1)!
        silentBuffer.frameLength = 1
        silentBuffer.floatChannelData?[0][0] = 0

        playerNode.scheduleBuffer(silentBuffer, at: endTime, options: []) { [weak self] in
            DispatchQueue.main.async {
                self?.isPlaying = false
                self?.onPlaybackComplete?()
            }
        }

        // Start playing if not already
        if !playerNode.isPlaying {
            playerNode.play()
        }
    }

    /// Play a single clap sound immediately
    func playClap() {
        playerNode.scheduleBuffer(clapBuffer, at: nil, options: [], completionHandler: nil)
        if !playerNode.isPlaying {
            playerNode.play()
        }
    }

    /// Play a click sound immediately
    func playClick() {
        playerNode.scheduleBuffer(clickBuffer, at: nil, options: [], completionHandler: nil)
        if !playerNode.isPlaying {
            playerNode.play()
        }
    }

    /// Stop current playback
    func stopPlayback() {
        playerNode.stop()
        isPlaying = false
    }

    /// Duration of the pattern playback including optional count-in
    func playbackDuration(for pattern: RhythmPattern, atBPM bpm: Int, includeCountIn: Bool) -> TimeInterval {
        let patternDuration = pattern.durationInSeconds(atBPM: bpm)
        let countInDuration = includeCountIn ? (120.0 / Double(bpm)) : 0 // 2 beats
        return countInDuration + patternDuration
    }
}
