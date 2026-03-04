#!/bin/bash
# sync.sh - CLI utilities for building/running DrumBuddy without opening Xcode
# Works with Xcode 16+ PBXFileSystemSynchronizedRootGroup (auto-discovers files)

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT="$PROJECT_DIR/DrumBuddy.xcodeproj"
SCHEME="DrumBuddy"
SIMULATOR="iPhone 17 Pro"
DERIVED_DATA="$PROJECT_DIR/.build/DerivedData"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

usage() {
    echo "Usage: ./sync.sh <command>"
    echo ""
    echo "Commands:"
    echo "  build    Build the project (catches compile errors)"
    echo "  run      Build and launch on simulator"
    echo "  test     Run unit tests"
    echo "  reload   Tell Xcode to reload externally-modified files"
    echo "  watch    Auto-build on .swift file changes (requires fswatch)"
    echo "  clean    Remove derived data"
    echo ""
}

cmd_build() {
    echo -e "${CYAN}Building DrumBuddy...${NC}"
    xcodebuild build \
        -project "$PROJECT" \
        -scheme "$SCHEME" \
        -destination "platform=iOS Simulator,name=$SIMULATOR" \
        -derivedDataPath "$DERIVED_DATA" \
        -quiet \
        2>&1
    local status=$?
    if [ $status -eq 0 ]; then
        echo -e "${GREEN}Build succeeded.${NC}"
    else
        echo -e "${RED}Build failed.${NC}"
    fi
    return $status
}

cmd_run() {
    echo -e "${CYAN}Building and running DrumBuddy on $SIMULATOR...${NC}"

    # Boot simulator if needed
    xcrun simctl boot "$SIMULATOR" 2>/dev/null || true
    open -a Simulator

    # Build
    xcodebuild build \
        -project "$PROJECT" \
        -scheme "$SCHEME" \
        -destination "platform=iOS Simulator,name=$SIMULATOR" \
        -derivedDataPath "$DERIVED_DATA" \
        -quiet

    # Find and install the app
    APP_PATH=$(find "$DERIVED_DATA" -name "DrumBuddy.app" -type d | head -1)
    if [ -z "$APP_PATH" ]; then
        echo -e "${RED}Could not find built app.${NC}"
        return 1
    fi

    xcrun simctl install "$SIMULATOR" "$APP_PATH"

    # Get bundle ID and launch
    BUNDLE_ID=$(defaults read "$APP_PATH/Info.plist" CFBundleIdentifier 2>/dev/null || echo "com.drumbuddy.DrumBuddy")
    xcrun simctl launch "$SIMULATOR" "$BUNDLE_ID"

    echo -e "${GREEN}App launched on $SIMULATOR.${NC}"
}

cmd_test() {
    echo -e "${CYAN}Running tests...${NC}"
    xcodebuild test \
        -project "$PROJECT" \
        -scheme "$SCHEME" \
        -destination "platform=iOS Simulator,name=$SIMULATOR" \
        -derivedDataPath "$DERIVED_DATA" \
        -quiet \
        2>&1
    local status=$?
    if [ $status -eq 0 ]; then
        echo -e "${GREEN}Tests passed.${NC}"
    else
        echo -e "${RED}Tests failed.${NC}"
    fi
    return $status
}

cmd_reload() {
    echo -e "${CYAN}Telling Xcode to reload files...${NC}"
    osascript -e '
        tell application "Xcode"
            activate
        end tell
        tell application "System Events"
            tell process "Xcode"
                -- Revert open document (Xcode reloads from disk)
                try
                    click menu item "Revert to Saved..." of menu "File" of menu bar 1
                    delay 0.5
                    -- Click Revert in the confirmation dialog
                    try
                        click button "Revert" of sheet 1 of window 1
                    end try
                end try
            end tell
        end tell
    ' 2>/dev/null || true

    # Alternative: just activate Xcode which triggers its file-watching
    osascript -e 'tell application "Xcode" to activate' 2>/dev/null

    echo -e "${GREEN}Xcode activated. Modified files should reload automatically.${NC}"
    echo -e "${YELLOW}Tip: Xcode 16+ with filesystem sync picks up new/deleted files automatically.${NC}"
}

cmd_watch() {
    if ! command -v fswatch &>/dev/null; then
        echo -e "${RED}fswatch not found. Install with: brew install fswatch${NC}"
        return 1
    fi

    echo -e "${CYAN}Watching .swift files for changes (Ctrl+C to stop)...${NC}"
    fswatch -o --include='\.swift$' --exclude='.*' "$PROJECT_DIR/DrumBuddy" \
        | while read -r _; do
            echo -e "\n${YELLOW}Change detected, building...${NC}"
            cmd_build || true
        done
}

cmd_clean() {
    echo -e "${CYAN}Cleaning derived data...${NC}"
    rm -rf "$DERIVED_DATA"
    echo -e "${GREEN}Clean complete.${NC}"
}

# Main
case "${1:-}" in
    build)  cmd_build ;;
    run)    cmd_run ;;
    test)   cmd_test ;;
    reload) cmd_reload ;;
    watch)  cmd_watch ;;
    clean)  cmd_clean ;;
    *)      usage ;;
esac
