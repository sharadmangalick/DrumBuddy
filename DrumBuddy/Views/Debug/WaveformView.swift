//
//  WaveformView.swift
//  DrumBuddy
//
//  Real-time waveform visualization
//

import SwiftUI

/// Displays a real-time waveform
struct WaveformView: View {
    let levels: [Float]
    let threshold: Float

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))

                // Waveform bars
                HStack(spacing: 2) {
                    ForEach(Array(levels.enumerated()), id: \.offset) { index, level in
                        WaveformBar(
                            level: CGFloat(level * 3), // Scale up for visibility
                            isAboveThreshold: level > threshold,
                            maxHeight: geometry.size.height - 8
                        )
                    }
                }
                .padding(4)

                // Threshold line
                Rectangle()
                    .fill(Color.orange.opacity(0.5))
                    .frame(height: 2)
                    .offset(y: thresholdOffset(in: geometry.size.height))
            }
        }
    }

    private func thresholdOffset(in height: CGFloat) -> CGFloat {
        let normalizedThreshold = CGFloat(threshold * 3)
        let barHeight = min(normalizedThreshold, 1.0) * (height - 8)
        return (height / 2) - (barHeight / 2)
    }
}

/// Single bar in the waveform
struct WaveformBar: View {
    let level: CGFloat
    let isAboveThreshold: Bool
    let maxHeight: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(isAboveThreshold ? Color.green : Color.blue.opacity(0.6))
            .frame(width: 4, height: barHeight)
    }

    private var barHeight: CGFloat {
        let normalized = min(max(level, 0), 1)
        return max(4, normalized * maxHeight)
    }
}

/// Simple level meter with peak hold
struct PeakLevelMeter: View {
    let level: Float
    let peakLevel: Float

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))

                // Current level
                RoundedRectangle(cornerRadius: 4)
                    .fill(levelGradient)
                    .frame(width: geometry.size.width * CGFloat(min(level * 3, 1)))

                // Peak indicator
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 3)
                    .offset(x: geometry.size.width * CGFloat(min(peakLevel * 3, 1)) - 1.5)
            }
        }
        .frame(height: 20)
    }

    private var levelGradient: LinearGradient {
        LinearGradient(
            colors: [.green, .yellow, .red],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        WaveformView(
            levels: (0..<50).map { _ in Float.random(in: 0...0.5) },
            threshold: 0.3
        )
        .frame(height: 100)

        PeakLevelMeter(level: 0.4, peakLevel: 0.6)
    }
    .padding()
}
