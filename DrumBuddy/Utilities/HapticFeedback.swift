//
//  HapticFeedback.swift
//  DrumBuddy
//
//  Provides haptic feedback for UI interactions
//

import UIKit

/// Provides haptic feedback for UI interactions
struct HapticFeedback {

    /// Light impact feedback (button taps)
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    /// Medium impact feedback (selections)
    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    /// Heavy impact feedback (important actions)
    static func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }

    /// Success feedback (completing a task)
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    /// Warning feedback
    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }

    /// Error feedback
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    /// Selection changed feedback
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }

    /// Feedback for a beat hit
    static func beatHit() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }

    /// Feedback for star rating
    static func stars(_ count: Int) {
        switch count {
        case 3:
            success()
        case 2:
            medium()
        case 1:
            light()
        default:
            break
        }
    }
}
