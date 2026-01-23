//
//  CountdownView.swift
//  DrumBuddy
//
//  Countdown display for practice start
//

import SwiftUI

/// Displays countdown before recording starts
struct CountdownView: View {
    let value: Int
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            // Countdown number
            Text("\(value)")
                .font(.system(size: 150, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
        .onChange(of: value) { _, newValue in
            // Animate each number change
            scale = 0.5
            opacity = 0.5
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
            HapticFeedback.medium()
        }
    }
}

/// Pulsing indicator for recording state
struct RecordingPulse: View {
    @State private var isPulsing = false

    var body: some View {
        Circle()
            .fill(Color.red)
            .frame(width: 20, height: 20)
            .scaleEffect(isPulsing ? 1.3 : 1.0)
            .opacity(isPulsing ? 0.6 : 1.0)
            .animation(
                .easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        CountdownView(value: 2)
    }
}
