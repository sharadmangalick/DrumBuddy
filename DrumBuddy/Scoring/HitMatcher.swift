//
//  HitMatcher.swift
//  DrumBuddy
//
//  Matches detected hits to expected beats
//

import Foundation

/// Matches detected drum hits to expected pattern beats
struct HitMatcher {

    /// Match detected hits to expected beat times
    /// - Parameters:
    ///   - detectedHits: Hits detected from microphone
    ///   - expectedTimes: Expected hit times from the pattern (in seconds)
    ///   - toleranceMs: Timing tolerance in milliseconds
    /// - Returns: Array of HitMatch results
    static func matchHits(
        detected: [DetectedHit],
        expectedTimes: [TimeInterval],
        toleranceMs: Double
    ) -> [HitMatch] {
        let toleranceSeconds = toleranceMs / 1000.0

        // Sort both arrays
        let sortedDetected = detected.sorted()
        let sortedExpected = expectedTimes.sorted()

        // Track which detected hits have been used
        var usedDetectedIndices = Set<Int>()

        // Create matches for each expected beat
        var matches: [HitMatch] = []

        for expectedTime in sortedExpected {
            var bestMatchIndex: Int?
            var bestOffset: Double = .infinity

            // Find the closest unused detected hit within tolerance
            for (index, hit) in sortedDetected.enumerated() {
                guard !usedDetectedIndices.contains(index) else { continue }

                let offset = hit.timestamp - expectedTime
                let absOffset = abs(offset)

                // Check if within tolerance
                if absOffset <= toleranceSeconds && absOffset < abs(bestOffset) {
                    bestMatchIndex = index
                    bestOffset = offset
                }
            }

            if let matchIndex = bestMatchIndex {
                // Found a match
                usedDetectedIndices.insert(matchIndex)
                let detectedTime = sortedDetected[matchIndex].timestamp
                let offsetMs = (detectedTime - expectedTime) * 1000.0

                matches.append(HitMatch(
                    expectedTime: expectedTime,
                    detectedTime: detectedTime,
                    offsetMs: offsetMs,
                    wasMatched: true
                ))
            } else {
                // No match found - missed beat
                matches.append(HitMatch(
                    expectedTime: expectedTime,
                    detectedTime: nil,
                    offsetMs: nil,
                    wasMatched: false
                ))
            }
        }

        return matches
    }

    /// Count extra hits (detected but not matching any expected beat)
    static func countExtraHits(
        detected: [DetectedHit],
        expectedTimes: [TimeInterval],
        toleranceMs: Double
    ) -> Int {
        let toleranceSeconds = toleranceMs / 1000.0

        var extraCount = 0

        for hit in detected {
            let hasMatch = expectedTimes.contains { expectedTime in
                abs(hit.timestamp - expectedTime) <= toleranceSeconds
            }

            if !hasMatch {
                extraCount += 1
            }
        }

        return extraCount
    }
}
