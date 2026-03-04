# DrumBuddy - Claude Code Project Guide

## What is DrumBuddy?
An iOS drumming practice app for kids. Users listen to rhythm patterns, tap along on their device, and receive scored feedback with kid-friendly encouragement.

## Project Structure
```
DrumBuddy/                    # Main app source (Xcode auto-syncs this folder)
├── DrumBuddyApp.swift        # App entry point
├── Audio/
│   ├── Detection/            # Onset detection (mic input → hit events)
│   ├── Engines/              # Audio engine coordination, mic capture, playback
│   ├── Processing/           # DSP: envelope follower, peak picker
│   └── Synthesis/            # Sound generation for metronome/guide sounds
├── Feedback/                 # TTS engine, kid-friendly phrases, feedback logic
├── Models/
│   ├── Persistence/          # SwiftData models (PatternStats, ProgressRecord)
│   ├── Rhythm/               # RhythmPattern, Beat, PatternLibrary, DifficultyTier
│   └── Session/              # PracticeSession, DetectedHit, SessionResult
├── Scoring/                  # Hit matching, tolerance calc, scoring engine
├── Settings/                 # CalibrationSettings
├── Utilities/                # Audio permissions, haptic feedback
├── ViewModels/               # MVVM view models (Home, Practice, Progress, Debug)
└── Views/
    ├── Calibration/
    ├── Components/           # Reusable UI (StarRating, BigButton)
    ├── Home/                 # HomeView, DifficultySelector
    ├── Practice/             # PracticeView, ResultsView, CountdownView
    └── Progress/             # StatsView
DrumBuddyTests/              # Unit tests
DrumBuddyUITests/            # UI tests
DrumBuddy.xcodeproj/         # Xcode project (uses PBXFileSystemSynchronizedRootGroup)
```

## Build & Verify
```bash
./sync.sh build    # Build from CLI (catches compile errors without opening Xcode)
./sync.sh test     # Run unit tests
./sync.sh run      # Build and launch on simulator
./sync.sh reload   # Tell Xcode to reload changed files
./sync.sh clean    # Remove derived data
```

**Always run `./sync.sh build` after making changes to verify they compile.**

## Conventions

### Swift & SwiftUI
- **SwiftUI** for all views, **MVVM** architecture
- **@MainActor** isolation on ViewModels and UI-related code
- **async/await** for concurrency (no Combine)
- **SwiftData** for persistence (not Core Data)
- Target: iOS 17+

### File Naming
- Views: `FeatureNameView.swift` (e.g., `PracticeView.swift`)
- ViewModels: `FeatureNameViewModel.swift` (e.g., `PracticeViewModel.swift`)
- Models: descriptive noun (e.g., `RhythmPattern.swift`, `DetectedHit.swift`)
- One primary type per file, filename matches the type name

### Code Style
- Use `struct` for Views, `class` (with `@Observable`) for ViewModels
- Keep Views thin - business logic belongs in ViewModels
- Use `private` access control by default
- Group related files in subdirectories matching their domain

## Xcode Sync
This project uses **PBXFileSystemSynchronizedRootGroup** (Xcode 16+). This means:
- New files added to the `DrumBuddy/` folder are **automatically discovered** by Xcode
- Deleted/renamed files are **automatically reflected** - no pbxproj edits needed
- Just create/edit/delete `.swift` files and Xcode picks them up

## Testing
- Unit tests go in `DrumBuddyTests/`
- UI tests go in `DrumBuddyUITests/`
- Run tests: `./sync.sh test`
