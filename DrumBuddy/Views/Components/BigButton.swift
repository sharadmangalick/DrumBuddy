//
//  BigButton.swift
//  DrumBuddy
//
//  Large, kid-friendly button component
//

import SwiftUI

/// A large, easy-to-tap button for kids
struct BigButton: View {
    let title: String
    let emoji: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: {
            HapticFeedback.medium()
            action()
        }) {
            VStack(spacing: 8) {
                Text(emoji)
                    .font(.system(size: 50))

                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .background(color.gradient)
            .foregroundColor(.white)
            .cornerRadius(24)
            .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

/// A smaller action button
struct ActionButton: View {
    let title: String
    let systemImage: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: {
            HapticFeedback.light()
            action()
        }) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.title2)
                Text(title)
                    .font(.headline)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(color.gradient)
            .foregroundColor(.white)
            .cornerRadius(16)
            .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

/// A circular button with just an icon
struct CircleButton: View {
    let systemImage: String
    let color: Color
    let size: CGFloat
    let action: () -> Void

    init(systemImage: String, color: Color = .blue, size: CGFloat = 60, action: @escaping () -> Void) {
        self.systemImage = systemImage
        self.color = color
        self.size = size
        self.action = action
    }

    var body: some View {
        Button(action: {
            HapticFeedback.light()
            action()
        }) {
            Image(systemName: systemImage)
                .font(.system(size: size * 0.4))
                .frame(width: size, height: size)
                .background(color.gradient)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 20) {
        BigButton(
            title: "Practice",
            emoji: "🥁",
            color: .blue
        ) {}

        HStack(spacing: 16) {
            ActionButton(
                title: "Listen",
                systemImage: "play.fill",
                color: .green
            ) {}

            ActionButton(
                title: "Try Again",
                systemImage: "arrow.counterclockwise",
                color: .orange
            ) {}
        }

        HStack(spacing: 20) {
            CircleButton(systemImage: "minus", color: .gray) {}
            CircleButton(systemImage: "plus", color: .gray) {}
        }
    }
    .padding()
}
