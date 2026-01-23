//
//  FeedbackEngine.swift
//  DrumBuddy
//
//  Generates and delivers feedback for practice sessions
//

import Foundation

/// Engine for generating and delivering feedback
@Observable
class FeedbackEngine {
    /// TTS engine for verbal feedback
    let ttsEngine = TTSEngine()

    /// Last feedback message
    private(set) var lastFeedback: FeedbackMessage?

    /// Whether to use TTS
    var useTTS: Bool = true

    /// Generate and deliver feedback for a result
    func deliverFeedback(for result: SessionResult) {
        let feedback = FeedbackMessage.create(from: result)
        lastFeedback = feedback

        // Speak the feedback
        if useTTS {
            ttsEngine.speakFeedback(feedback)
        }
    }

    /// Generate feedback message without delivering
    func generateFeedback(for result: SessionResult) -> FeedbackMessage {
        return FeedbackMessage.create(from: result)
    }

    /// Speak a custom message
    func speak(_ message: String) {
        if useTTS {
            ttsEngine.speak(message)
        }
    }

    /// Speak encouragement for a specific situation
    func speakEncouragement() {
        let phrases = [
            "You can do it!",
            "Let's try again!",
            "Ready? Here we go!",
            "Listen carefully!",
            "You've got this!"
        ]

        if let phrase = phrases.randomElement() {
            speak(phrase)
        }
    }

    /// Speak countdown
    func speakCountdown() {
        speak("Ready? One, two!")
    }

    /// Stop any current speech
    func stopSpeaking() {
        ttsEngine.stop()
    }
}
