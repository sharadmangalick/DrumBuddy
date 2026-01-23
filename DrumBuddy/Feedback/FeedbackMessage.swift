//
//  FeedbackMessage.swift
//  DrumBuddy
//
//  Structured feedback message for practice results
//

import Foundation

/// A structured feedback message
struct FeedbackMessage {
    /// Main encouragement phrase
    let mainPhrase: String

    /// Specific feedback about performance (optional)
    let specificFeedback: String?

    /// Whether to play celebration sound/animation
    let shouldCelebrate: Bool

    /// Full message for TTS
    var fullMessage: String {
        if let specific = specificFeedback {
            return "\(mainPhrase) \(specific)"
        }
        return mainPhrase
    }

    /// Create feedback for a session result
    static func create(from result: SessionResult) -> FeedbackMessage {
        let mainPhrase = KidFriendlyPhrases.randomPhrase(
            for: result.starRating,
            isPerfect: result.isPerfect
        )

        var specificFeedback: String?

        // Add specific feedback for non-perfect attempts
        if !result.isPerfect {
            if result.missedHits > 0 && result.missedHits > result.extraHits {
                specificFeedback = KidFriendlyPhrases.missedBeatsFeedback(count: result.missedHits)
            } else if result.extraHits > 0 && result.extraHits > result.missedHits {
                specificFeedback = KidFriendlyPhrases.extraHitsFeedback(count: result.extraHits)
            } else if result.matchedHits > 0 {
                specificFeedback = KidFriendlyPhrases.timingFeedback(averageOffsetMs: result.averageOffsetMs)
            }
        }

        return FeedbackMessage(
            mainPhrase: mainPhrase,
            specificFeedback: specificFeedback,
            shouldCelebrate: result.starRating >= 3
        )
    }
}
