//
//  AudioPermissions.swift
//  DrumBuddy
//
//  Handles microphone permission requests
//

import AVFoundation

/// Handles microphone permission requests and status
struct AudioPermissions {

    /// Current authorization status
    static var status: AVAudioSession.RecordPermission {
        AVAudioSession.sharedInstance().recordPermission
    }

    /// Whether we have permission to record
    static var isAuthorized: Bool {
        status == .granted
    }

    /// Whether permission has been denied
    static var isDenied: Bool {
        status == .denied
    }

    /// Request microphone permission
    /// - Parameter completion: Called with the result (true if granted)
    static func requestPermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    /// Request permission using async/await
    static func requestPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            requestPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }
}
