//
//  DifficultySelector.swift
//  DrumBuddy
//
//  Difficulty tier selection component
//

import SwiftUI

/// Horizontal difficulty tier selector
struct DifficultySelector: View {
    @Binding var selectedDifficulty: DifficultyTier

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(DifficultyTier.allCases) { tier in
                    DifficultyButton(
                        tier: tier,
                        isSelected: selectedDifficulty == tier,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedDifficulty = tier
                            }
                            HapticFeedback.selection()
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

/// Single difficulty tier button
struct DifficultyButton: View {
    let tier: DifficultyTier
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(tier.emoji)
                    .font(.system(size: 30))

                Text(tier.displayName)
                    .font(.caption)
                    .fontWeight(isSelected ? .bold : .regular)
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? tierColor.opacity(0.2) : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? tierColor : Color.clear, lineWidth: 3)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(.plain)
    }

    private var tierColor: Color {
        switch tier {
        case .beginner: return .green
        case .easyPeasy: return .blue
        case .gettingGood: return .orange
        case .rockStar: return .purple
        case .drumHero: return .red
        }
    }
}

/// Grid-style difficulty selector
struct DifficultyGrid: View {
    @Binding var selectedDifficulty: DifficultyTier

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(DifficultyTier.allCases) { tier in
                DifficultyCard(
                    tier: tier,
                    isSelected: selectedDifficulty == tier,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedDifficulty = tier
                        }
                        HapticFeedback.selection()
                    }
                )
            }
        }
        .padding(.horizontal)
    }
}

/// Larger difficulty card for grid
struct DifficultyCard: View {
    let tier: DifficultyTier
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(tier.emoji)
                    .font(.system(size: 40))

                Text(tier.displayName)
                    .font(.footnote)
                    .fontWeight(isSelected ? .bold : .regular)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? tierColor.opacity(0.2) : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? tierColor : Color.clear, lineWidth: 3)
            )
        }
        .buttonStyle(.plain)
    }

    private var tierColor: Color {
        switch tier {
        case .beginner: return .green
        case .easyPeasy: return .blue
        case .gettingGood: return .orange
        case .rockStar: return .purple
        case .drumHero: return .red
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        DifficultySelector(selectedDifficulty: .constant(.beginner))

        DifficultyGrid(selectedDifficulty: .constant(.gettingGood))
    }
}
