//
//  ResultsView.swift
//  DrumBuddy
//
//  Displays practice session results
//

import SwiftUI

/// Displays the results of a practice session
struct ResultsView: View {
    let result: SessionResult
    let pattern: RhythmPattern
    let onTryAgain: () -> Void
    let onNextPattern: () -> Void

    @State private var showConfetti = false

    var body: some View {
        VStack(spacing: 24) {
            // Stars
            LargeStarRating(rating: result.starRating)
                .padding(.top, 20)

            // Score
            Text("\(result.overallScore)")
                .font(.system(size: 80, weight: .bold, design: .rounded))
                .foregroundColor(scoreColor)

            Text("points")
                .font(.title3)
                .foregroundColor(.secondary)

            // Feedback message
            Text(result.feedbackMessage)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Stats
            HStack(spacing: 30) {
                StatBox(
                    value: "\(result.matchedHits)/\(result.expectedHits)",
                    label: "Hits"
                )

                if result.extraHits > 0 {
                    StatBox(
                        value: "+\(result.extraHits)",
                        label: "Extra",
                        color: .orange
                    )
                }

                if abs(result.averageOffsetMs) > 10 {
                    StatBox(
                        value: result.averageOffsetMs > 0 ? "Late" : "Early",
                        label: "\(Int(abs(result.averageOffsetMs)))ms",
                        color: .blue
                    )
                }
            }

            Spacer()

            // Action buttons
            VStack(spacing: 16) {
                BigButton(
                    title: "Try Again",
                    emoji: "🔄",
                    color: .orange,
                    action: onTryAgain
                )

                if result.starRating >= 2 {
                    BigButton(
                        title: "Next Pattern",
                        emoji: "➡️",
                        color: .green,
                        action: onNextPattern
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .overlay {
            if showConfetti && result.starRating >= 3 {
                ConfettiView()
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            if result.starRating >= 3 {
                showConfetti = true
            }
        }
    }

    private var scoreColor: Color {
        switch result.starRating {
        case 3: return .green
        case 2: return .orange
        case 1: return .yellow
        default: return .gray
        }
    }
}

/// Small stat display box
struct StatBox: View {
    let value: String
    let label: String
    var color: Color = .primary

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

/// Simple confetti effect
struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Text(particle.emoji)
                        .font(.system(size: particle.size))
                        .position(particle.position)
                        .opacity(particle.opacity)
                }
            }
            .onAppear {
                createParticles(in: geometry.size)
                animateParticles(in: geometry.size)
            }
        }
    }

    private func createParticles(in size: CGSize) {
        let emojis = ["🎉", "⭐", "✨", "🌟", "🎊", "💫"]

        particles = (0..<30).map { _ in
            ConfettiParticle(
                emoji: emojis.randomElement()!,
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: -50
                ),
                size: CGFloat.random(in: 20...40),
                opacity: 1.0
            )
        }
    }

    private func animateParticles(in size: CGSize) {
        for index in particles.indices {
            let delay = Double.random(in: 0...0.5)
            let duration = Double.random(in: 1.5...2.5)

            withAnimation(.easeOut(duration: duration).delay(delay)) {
                particles[index].position.y = size.height + 100
                particles[index].position.x += CGFloat.random(in: -100...100)
            }

            withAnimation(.easeIn(duration: 0.5).delay(delay + duration - 0.5)) {
                particles[index].opacity = 0
            }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    let emoji: String
    var position: CGPoint
    let size: CGFloat
    var opacity: Double
}

#Preview {
    ResultsView(
        result: SessionResult(
            overallScore: 85,
            starRating: 3,
            expectedHits: 4,
            matchedHits: 4,
            extraHits: 0,
            missedHits: 0,
            averageOffsetMs: 15,
            hitMatches: [],
            feedbackMessage: "Great job! You got all the beats!"
        ),
        pattern: PatternLibrary.beginnerPatterns[0],
        onTryAgain: {},
        onNextPattern: {}
    )
}
