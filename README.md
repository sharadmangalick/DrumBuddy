# 🥁 DrumBuddy

A fun iOS app to help kids learn drumming by playing rhythm patterns and detecting their drum hits via microphone!

## Features

- **25+ Hand-Crafted Rhythm Patterns** across 5 difficulty levels
- **Real-Time Drum Detection** using energy-based onset detection
- **Kid-Friendly UI** with big buttons, emojis, and encouraging feedback
- **Text-to-Speech Feedback** celebrates successes and guides improvement
- **Progress Tracking** with stars, scores, and practice history
- **Procedural Pattern Generation** for unlimited practice variety

## Difficulty Levels

| Level | Emoji | Description |
|-------|-------|-------------|
| Beginner | 🐣 | Quarter notes only, 50-60 BPM |
| Easy Peasy | 🌟 | Quarter + half notes, 55-65 BPM |
| Getting Good | 🔥 | Quarter + eighth notes, 60-75 BPM |
| Rock Star | 🎸 | Syncopation + off-beats, 65-80 BPM |
| Drum Hero | 👑 | Triplets + complex rhythms, 70-90 BPM |

## How It Works

1. **Select a Pattern** - Choose a difficulty level and pick a pattern
2. **Listen** - Tap "Listen" to hear the rhythm pattern
3. **Practice** - Tap "Practice" to play along on your drums
4. **Get Feedback** - Receive a score (0-3 stars) and encouraging feedback

## Technical Details

### Audio Detection
- Energy-based onset detection with envelope follower
- Configurable threshold, noise floor, and refractory period
- Protocol-based design ready for future ML model integration

### Architecture
- **SwiftUI** with iOS 17+ features (@Observable, SwiftData)
- **AVAudioEngine** for low-latency audio playback and capture
- **SwiftData** for progress persistence
- **AVSpeechSynthesizer** for text-to-speech feedback

### Project Structure
```
DrumBuddy/
├── Models/          # Data models (Beat, RhythmPattern, etc.)
├── Audio/           # Audio engines and onset detection
├── Scoring/         # Hit matching and scoring logic
├── Feedback/        # TTS and kid-friendly phrases
├── ViewModels/      # View state management
├── Views/           # SwiftUI views
├── Settings/        # Calibration settings
└── Utilities/       # Helpers (permissions, haptics)
```

## Requirements

- iOS 17.0+
- iPhone or iPad
- Microphone access (for drum detection)

## Hidden Features

- **Calibration Settings**: Long-press the "DrumBuddy" title for 2 seconds to access advanced detection settings
- **Debug View**: Tap the waveform icon to see real-time audio levels and detected hits

## Building

1. Open `DrumBuddy.xcodeproj` in Xcode 15+
2. Select your target device or simulator
3. Press ⌘R to build and run

Note: Microphone detection only works on a real device, not the simulator.

## Privacy

DrumBuddy only uses the microphone to detect drum hits in real-time. **No audio is recorded, stored, or uploaded.** All processing happens on-device.

## License

MIT License - Feel free to use this as a learning resource or starting point for your own projects!

---

Built with ❤️ for young drummers everywhere
