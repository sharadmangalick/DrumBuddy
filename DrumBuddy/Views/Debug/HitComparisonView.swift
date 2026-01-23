//
//  HitComparisonView.swift
//  DrumBuddy
//
//  Compares expected vs detected hits for debugging
//

import SwiftUI

/// Table comparing expected and detected hits
struct HitComparisonView: View {
    let matches: [HitMatch]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Text("Expected")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Detected")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Offset")
                    .frame(width: 80, alignment: .trailing)
            }
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.secondary)
            .padding(.horizontal)

            Divider()

            // Rows
            ForEach(matches) { match in
                HitMatchRow(match: match)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

/// Single row in hit comparison
struct HitMatchRow: View {
    let match: HitMatch

    var body: some View {
        HStack {
            // Expected time
            Text(formatTime(match.expectedTime))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.blue)

            // Detected time
            if let detected = match.detectedTime {
                Text(formatTime(detected))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.green)
            } else {
                Text("MISSED")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.red)
            }

            // Offset
            if let offset = match.offsetMs {
                Text(formatOffset(offset))
                    .frame(width: 80, alignment: .trailing)
                    .foregroundColor(offsetColor(offset))
            } else {
                Text("-")
                    .frame(width: 80, alignment: .trailing)
                    .foregroundColor(.secondary)
            }
        }
        .font(.system(.body, design: .monospaced))
        .padding(.horizontal)
        .padding(.vertical, 4)
        .background(match.wasMatched ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        .cornerRadius(4)
    }

    private func formatTime(_ time: TimeInterval) -> String {
        String(format: "%.3fs", time)
    }

    private func formatOffset(_ offset: Double) -> String {
        let sign = offset >= 0 ? "+" : ""
        return String(format: "%@%.0fms", sign, offset)
    }

    private func offsetColor(_ offset: Double) -> Color {
        let absOffset = abs(offset)
        if absOffset < 30 {
            return .green
        } else if absOffset < 80 {
            return .orange
        }
        return .red
    }
}

/// Summary of hit detection results
struct HitSummaryView: View {
    let matched: Int
    let missed: Int
    let extra: Int
    let averageOffset: Double

    var body: some View {
        HStack(spacing: 20) {
            SummaryItem(
                value: "\(matched)",
                label: "Matched",
                color: .green
            )

            SummaryItem(
                value: "\(missed)",
                label: "Missed",
                color: .red
            )

            SummaryItem(
                value: "\(extra)",
                label: "Extra",
                color: .orange
            )

            SummaryItem(
                value: String(format: "%.0fms", averageOffset),
                label: "Avg Offset",
                color: .blue
            )
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

/// Single summary item
struct SummaryItem: View {
    let value: String
    let label: String
    let color: Color

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
    }
}

#Preview {
    VStack(spacing: 20) {
        HitComparisonView(matches: [
            HitMatch(expectedTime: 0.5, detectedTime: 0.52, offsetMs: 20, wasMatched: true),
            HitMatch(expectedTime: 1.0, detectedTime: 1.08, offsetMs: 80, wasMatched: true),
            HitMatch(expectedTime: 1.5, detectedTime: nil, offsetMs: nil, wasMatched: false),
            HitMatch(expectedTime: 2.0, detectedTime: 1.95, offsetMs: -50, wasMatched: true)
        ])

        HitSummaryView(matched: 3, missed: 1, extra: 0, averageOffset: 16.7)
    }
    .padding()
}
