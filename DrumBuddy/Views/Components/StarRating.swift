//
//  StarRating.swift
//  DrumBuddy
//
//  Star rating display component
//

import SwiftUI

/// Displays a star rating (0-3 stars)
struct StarRating: View {
    let rating: Int
    let maxRating: Int
    let size: CGFloat
    let animated: Bool

    init(rating: Int, maxRating: Int = 3, size: CGFloat = 40, animated: Bool = false) {
        self.rating = rating
        self.maxRating = maxRating
        self.size = size
        self.animated = animated
    }

    var body: some View {
        HStack(spacing: size * 0.2) {
            ForEach(0..<maxRating, id: \.self) { index in
                starView(for: index)
            }
        }
    }

    @ViewBuilder
    private func starView(for index: Int) -> some View {
        let isFilled = index < rating

        Image(systemName: isFilled ? "star.fill" : "star")
            .font(.system(size: size))
            .foregroundColor(isFilled ? .yellow : .gray.opacity(0.3))
            .shadow(color: isFilled ? .yellow.opacity(0.5) : .clear, radius: 4)
            .scaleEffect(animated && isFilled ? 1.2 : 1.0)
            .animation(
                animated ? .spring(response: 0.3, dampingFraction: 0.6).delay(Double(index) * 0.15) : nil,
                value: rating
            )
    }
}

/// Large animated star rating for results screen
struct LargeStarRating: View {
    let rating: Int
    @State private var showStars = false

    var body: some View {
        HStack(spacing: 16) {
            ForEach(0..<3, id: \.self) { index in
                starView(for: index)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                showStars = true
            }
        }
    }

    @ViewBuilder
    private func starView(for index: Int) -> some View {
        let isFilled = index < rating
        let delay = Double(index) * 0.2

        Image(systemName: isFilled ? "star.fill" : "star")
            .font(.system(size: 60))
            .foregroundColor(isFilled ? .yellow : .gray.opacity(0.3))
            .shadow(color: isFilled ? .yellow.opacity(0.6) : .clear, radius: 8)
            .scaleEffect(showStars ? 1.0 : 0.3)
            .opacity(showStars ? 1.0 : 0.0)
            .animation(
                .spring(response: 0.5, dampingFraction: 0.6).delay(delay),
                value: showStars
            )
    }
}

#Preview {
    VStack(spacing: 30) {
        StarRating(rating: 0)
        StarRating(rating: 1)
        StarRating(rating: 2)
        StarRating(rating: 3)

        Divider()

        LargeStarRating(rating: 3)
    }
    .padding()
}
