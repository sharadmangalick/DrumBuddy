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

    /// Whether TTS is enabled
    var isEnabled: Bool = true

    /// Currently speaking
    var isSpeaking: Bool {
        synthesizer.isSpeaking
    }

    init() {
        // Use a friendly voice
        rate = AVSpeechUtteranceDefaultSpeechRate * 0.9 // Slightly slower for kids
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

        // Try to use a friendly voice
        if let voice = AVSpeechSynthesisVoice(language: "en-US") {
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
