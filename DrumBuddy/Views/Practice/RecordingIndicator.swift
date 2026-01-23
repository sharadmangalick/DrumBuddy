//
//  RecordingIndicator.swift
//  DrumBuddy
//
//  Visual indicator for recording state and audio level
//

import SwiftUI

/// Shows recording status and audio level
struct RecordingIndicator: View {
    let isRecording: Bool
    let audioLevel: Float

    var body: some View {
        HStack(spacing: 12) {
            // Recording dot
            if isRecording {
                RecordingPulse()
            }

            // Level meter
            AudioLevelMeter(level: audioLevel)
                .frame(width: 150, height: 30)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}

/// Simple audio level meter
struct AudioLevelMeter: View {
    let level: Float

    private var normalizedLevel: CGFloat {
        CGFloat(min(max(level * 3, 0), 1)) // Scale up for visibility
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))

                // Level bar
                RoundedRectangle(cornerRadius: 8)
                    .fill(levelColor)
                    .frame(width: geometry.size.width * normalizedLevel)
                    .animation(.linear(duration: 0.05), value: normalizedLevel)
            }
        }
    }

    private var levelColor: Color {
        if normalizedLevel > 0.8 {
            return .red
        } else if normalizedLevel > 0.5 {
            return .yellow
        }
        return .green
    }
}

/// Circular audio level indicator
struct CircularLevelIndicator: View {
    let level: Float
    let size: CGFloat

    @State private var animatedLevel: CGFloat = 0

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)

            // Level arc
            Circle()
                .trim(from: 0, to: animatedLevel)
                .stroke(levelColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.1), value: animatedLevel)

            // Mic icon
            Image(systemName: "mic.fill")
                .font(.system(size: size * 0.3))
                .foregroundColor(.primary)
        }
        .frame(width: size, height: size)
        .onChange(of: level) { _, newValue in
            animatedLevel = CGFloat(min(max(newValue * 3, 0), 1))
        }
    }

    private var levelColor: Color {
        if animatedLevel > 0.8 {
            return .red
        } else if animatedLevel > 0.5 {
            return .orange
        }
        return .green
    }
}

#Preview {
    VStack(spacing: 30) {
        RecordingIndicator(isRecording: true, audioLevel: 0.3)
        RecordingIndicator(isRecording: false, audioLevel: 0.1)

        CircularLevelIndicator(level: 0.5, size: 100)
    }
    .padding()
}
