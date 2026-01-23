//
//  KidFriendlyPhrases.swift
//  DrumBuddy
//
//  Kid-friendly feedback phrases for encouragement
//

import Foundation

/// Collection of kid-friendly feedback phrases
struct KidFriendlyPhrases {

    // MARK: - Celebration Phrases (3 stars)

    static let perfectPhrases = [
        "Wow! Perfect score! You're amazing!",
        "Incredible! You got every beat!",
        "You're a drumming superstar!",
        "That was absolutely perfect!",
        "Amazing! You nailed it!"
    ]

    static let threeStarPhrases = [
        "Great job! You've got the rhythm!",
        "Fantastic! Three stars for you!",
        "You're rocking it!",
        "Super awesome drumming!",
        "You're a rhythm master!"
    ]

    // MARK: - Good Effort Phrases (2 stars)

    static let twoStarPhrases = [
        "Nice work! Almost there!",
        "Good job! Keep practicing!",
        "You're getting really good!",
        "So close to three stars!",
        "Great effort! Try again!"
    ]

    // MARK: - Encouraging Phrases (1 star)

    static let oneStarPhrases = [
        "Good try! Let's practice more!",
        "You're learning! Keep going!",
        "Nice effort! Listen carefully and try again!",
        "You can do it! Try once more!",
        "Keep practicing! You're getting better!"
    ]

    // MARK: - Keep Trying Phrases (0 stars)

    static let zeroStarPhrases = [
        "Don't give up! Let's try again!",
        "That's okay! Practice makes perfect!",
        "Let's listen to the pattern again!",
        "You can do it! Try one more time!",
        "Keep trying! Every drummer starts somewhere!"
    ]

    // MARK: - Specific Feedback

    static func missedBeatsFeedback(count: Int) -> String {
        if count == 1 {
            return "You just missed one beat!"
        }
        return "You missed \(count) beats. Listen carefully!"
    }

    static func extraHitsFeedback(count: Int) -> String {
        if count == 1 {
            return "You added an extra hit!"
        }
        return "You added \(count) extra hits. Match the pattern exactly!"
    }

    static func timingFeedback(averageOffsetMs: Double) -> String {
        if averageOffsetMs > 50 {
            return "Try hitting a tiny bit earlier!"
        } else if averageOffsetMs < -50 {
            return "Try waiting just a little longer!"
        }
        return "Your timing is great!"
    }

    // MARK: - Improvement Phrases

    static let improvementPhrases = [
        "You're getting better!",
        "That was better than last time!",
        "See? Practice helps!",
        "You're improving!",
        "Nice improvement!"
    ]

    // MARK: - Random Selection

    static func randomPhrase(for stars: Int, isPerfect: Bool = false) -> String {
        if isPerfect {
            return perfectPhrases.randomElement() ?? threeStarPhrases[0]
        }

        switch stars {
        case 3: return threeStarPhrases.randomElement() ?? threeStarPhrases[0]
        case 2: return twoStarPhrases.randomElement() ?? twoStarPhrases[0]
        case 1: return oneStarPhrases.randomElement() ?? oneStarPhrases[0]
        default: return zeroStarPhrases.randomElement() ?? zeroStarPhrases[0]
        }
    }
}
