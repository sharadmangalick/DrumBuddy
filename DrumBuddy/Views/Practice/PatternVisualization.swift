//
//  PatternVisualization.swift
//  DrumBuddy
//
//  Visual representation of rhythm patterns
//

import SwiftUI

/// Displays a rhythm pattern visually
struct PatternVisualization: View {
    let pattern: RhythmPattern
    let currentBeatIndex: Int
    let showHitTimes: Bool

    init(pattern: RhythmPattern, currentBeatIndex: Int = -1, showHitTimes: Bool = false) {
        self.pattern = pattern
        self.currentBeatIndex = currentBeatIndex
        self.showHitTimes = showHitTimes
    }

    var body: some View {
        VStack(spacing: 8) {
            // Pattern name
            HStack {
                Text(pattern.emoji)
                    .font(.title)
                Text(pattern.name)
                    .font(.headline)
            }

            // Beat visualization
            HStack(spacing: 8) {
                ForEach(Array(pattern.hits.enumerated()), id: \.element.id) { index, beat in
                    BeatDot(
                        isActive: index == currentBeatIndex,
                        position: beat.positionInBeats
                    )
                }
            }
            .padding(.vertical, 8)

            // Hit count
            Text("\(pattern.hits.count) beats")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

/// Single beat dot in visualization
struct BeatDot: View {
    let isActive: Bool
    let position: Double

    var body: some View {
        Circle()
            .fill(isActive ? Color.orange : Color.blue)
            .frame(width: isActive ? 30 : 24, height: isActive ? 30 : 24)
            .scaleEffect(isActive ? 1.2 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isActive)
    }
}

/// Timeline visualization of expected vs detected hits
struct HitTimelineView: View {
    let expectedTimes: [TimeInterval]
    let detectedTimes: [TimeInterval]
    let duration: TimeInterval
    let toleranceMs: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Timeline background
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 60)

                // Tolerance zones for expected hits
                ForEach(Array(expectedTimes.enumerated()), id: \.offset) { _, time in
                    let xPosition = CGFloat(time / duration) * geometry.size.width
                    let toleranceWidth = CGFloat(toleranceMs / 1000 / duration) * geometry.size.width * 2

                    Rectangle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: toleranceWidth, height: 60)
                        .position(x: xPosition, y: 30)
                }

                // Expected hits (top row)
                ForEach(Array(expectedTimes.enumerated()), id: \.offset) { _, time in
                    let xPosition = CGFloat(time / duration) * geometry.size.width

                    Circle()
                        .fill(Color.blue)
                        .frame(width: 16, height: 16)
                        .position(x: xPosition, y: 15)
                }

                // Detected hits (bottom row)
                ForEach(Array(detectedTimes.enumerated()), id: \.offset) { _, time in
                    let xPosition = CGFloat(time / duration) * geometry.size.width

                    Circle()
                        .fill(Color.orange)
                        .frame(width: 16, height: 16)
                        .position(x: xPosition, y: 45)
                }
            }
        }
        .frame(height: 60)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    VStack(spacing: 20) {
        PatternVisualization(
            pattern: PatternLibrary.beginnerPatterns[0],
            currentBeatIndex: 1
        )

        HitTimelineView(
            expectedTimes: [0.5, 1.0, 1.5, 2.0],
            detectedTimes: [0.52, 1.05, 1.48, 2.1],
            duration: 2.5,
            toleranceMs: 150
        )
        .padding()
    }
    .padding()
}
