//
//  SoundGenerator.swift
//  DrumBuddy
//
//  Programmatic synthesis of clap and click sounds
//

import AVFoundation

/// Generates synthesized percussion sounds without audio files
class SoundGenerator {

    /// Generate a clap-like sound: filtered noise burst with fast decay
    static func generateClap(sampleRate: Double = 44100) -> AVAudioPCMBuffer {
        let duration = 0.08  // 80ms
        let frameCount = AVAudioFrameCount(duration * sampleRate)

        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
              let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            fatalError("Failed to create audio buffer")
        }

        buffer.frameLength = frameCount

        guard let data = buffer.floatChannelData?[0] else { return buffer }

        for i in 0..<Int(frameCount) {
            let t = Double(i) / sampleRate

            // White noise
            let noise = Float.random(in: -1...1)

            // Exponential decay envelope
            let envelope = Float(exp(-t * 50))

            // Apply some filtering by mixing with previous sample
            let filtered = noise * 0.7

            data[i] = filtered * envelope * 0.8
        }

        // Simple low-pass by averaging adjacent samples
        for i in 1..<Int(frameCount) {
            data[i] = (data[i] + data[i-1]) * 0.5
        }

        return buffer
    }

    /// Generate a click sound for count-in: short sine burst
    static func generateClick(sampleRate: Double = 44100) -> AVAudioPCMBuffer {
        let duration = 0.03  // 30ms
        let frequency = 800.0  // 800Hz tone
        let frameCount = AVAudioFrameCount(duration * sampleRate)

        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
              let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            fatalError("Failed to create audio buffer")
        }

        buffer.frameLength = frameCount

        guard let data = buffer.floatChannelData?[0] else { return buffer }

        for i in 0..<Int(frameCount) {
            let t = Double(i) / sampleRate

            // Sine wave
            let sine = Float(sin(2.0 * .pi * frequency * t))

            // Fast exponential decay
            let envelope = Float(exp(-t * 80))

            data[i] = sine * envelope * 0.6
        }

        return buffer
    }

    /// Generate an accented click (higher pitch, slightly louder)
    static func generateAccentClick(sampleRate: Double = 44100) -> AVAudioPCMBuffer {
        let duration = 0.04  // 40ms
        let frequency = 1200.0  // Higher pitch
        let frameCount = AVAudioFrameCount(duration * sampleRate)

        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
              let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            fatalError("Failed to create audio buffer")
        }

        buffer.frameLength = frameCount

        guard let data = buffer.floatChannelData?[0] else { return buffer }

        for i in 0..<Int(frameCount) {
            let t = Double(i) / sampleRate

            // Sine wave with some harmonics
            let fundamental = Float(sin(2.0 * .pi * frequency * t))
            let harmonic = Float(sin(2.0 * .pi * frequency * 2.0 * t)) * 0.3

            // Fast decay
            let envelope = Float(exp(-t * 60))

            data[i] = (fundamental + harmonic) * envelope * 0.7
        }

        return buffer
    }

    /// Generate a soft metronome tick
    static func generateTick(sampleRate: Double = 44100) -> AVAudioPCMBuffer {
        let duration = 0.015  // 15ms
        let frequency = 1500.0
        let frameCount = AVAudioFrameCount(duration * sampleRate)

        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
              let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            fatalError("Failed to create audio buffer")
        }

        buffer.frameLength = frameCount

        guard let data = buffer.floatChannelData?[0] else { return buffer }

        for i in 0..<Int(frameCount) {
            let t = Double(i) / sampleRate

            // Sharp sine burst
            let sine = Float(sin(2.0 * .pi * frequency * t))
            let envelope = Float(exp(-t * 150))

            data[i] = sine * envelope * 0.4
        }

        return buffer
    }
}
