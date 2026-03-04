//
//  TTSEngine.swift
//  DrumBuddy
//
//  Text-to-speech for verbal feedback
//

import AVFoundation

/// Engine for text-to-speech feedback
class TTSEngine {
    private let synthesizer = AVSpeechSynthesizer()

    /// Voice settings
    private var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    private var pitch: Float = 1.1  // Slightly higher pitch for friendliness
    private var volume: Float = 1.0

    /// Cached best available voice
    private var selectedVoice: AVSpeechSynthesisVoice?

    /// Whether TTS is enabled
    var isEnabled: Bool = true

    /// Currently speaking
    var isSpeaking: Bool {
        synthesizer.isSpeaking
    }

    init() {
        // Use a friendly voice
        rate = AVSpeechUtteranceDefaultSpeechRate * 0.9 // Slightly slower for kids
        selectedVoice = Self.findBestVoice()
    }

    /// Find the highest quality en-US voice available on this device.
    /// Prefers premium > enhanced > default, and favors female voices for a warm, friendly tone.
    private static func findBestVoice() -> AVSpeechSynthesisVoice? {
        let allVoices = AVSpeechSynthesisVoice.speechVoices()
        let enUSVoices = allVoices.filter { $0.language == "en-US" }

        // Try premium quality first, then enhanced, then default
        if let premium = enUSVoices.first(where: { $0.quality == .premium }) {
            return premium
        }
        if let enhanced = enUSVoices.first(where: { $0.quality == .enhanced }) {
            return enhanced
        }

        // Fall back to default quality but prefer Samantha (warm, friendly)
        if let samantha = enUSVoices.first(where: { $0.identifier.contains("Samantha") }) {
            return samantha
        }

        return AVSpeechSynthesisVoice(language: "en-US")
    }

    /// Speak a message
    func speak(_ message: String) {
        guard isEnabled else { return }

        // Stop any current speech
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: message)
        utterance.rate = rate
        utterance.pitchMultiplier = pitch
        utterance.volume = volume

        if let voice = selectedVoice {
            utterance.voice = voice
        }

        synthesizer.speak(utterance)
    }

    /// Speak feedback for a result
    func speakFeedback(_ feedback: FeedbackMessage) {
        speak(feedback.fullMessage)
    }

    /// Stop speaking
    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }

    /// Set speech rate (0.0 to 1.0)
    func setRate(_ newRate: Float) {
        rate = AVSpeechUtteranceMinimumSpeechRate +
               (AVSpeechUtteranceMaximumSpeechRate - AVSpeechUtteranceMinimumSpeechRate) * newRate
    }
}
