#!/bin/bash

# SwiftQuantum App Store Screenshots - All Languages
# Captures screenshots for EN, KO, JA, ZH-Hans, DE

SIMULATOR_ID="3E03F05C-E596-4516-A1BF-F1306F6EA53F"
BUNDLE_ID="com.eunminpark.swiftquantum"
BASE_DIR="/Users/eunmin/Desktop/WORK/SwiftQuantum/AppStoreAssets/Screenshots/iPhone_6.7"

# App Store size for iPhone 6.7"
TARGET_WIDTH=1284
TARGET_HEIGHT=2778

# Languages to capture
LANGUAGES=("en" "ko" "ja" "zh-Hans" "de")

capture_screenshot() {
    local lang=$1
    local name=$2
    local output_dir="$BASE_DIR/$lang"
    local temp_file="$output_dir/temp_${name}.png"
    local final_file="$output_dir/${name}.png"

    mkdir -p "$output_dir"

    # Capture
    xcrun simctl io "$SIMULATOR_ID" screenshot "$temp_file" 2>/dev/null

    # Resize to App Store dimensions
    sips -z $TARGET_HEIGHT $TARGET_WIDTH "$temp_file" --out "$final_file" 2>/dev/null

    # Remove temp
    rm -f "$temp_file"

    echo "  Captured: $lang/$name.png"
}

set_language_and_restart() {
    local lang=$1

    echo ""
    echo "Setting language to: $lang"

    # Set language preference
    xcrun simctl spawn "$SIMULATOR_ID" defaults write "$BUNDLE_ID" AppleLanguages -array "$lang"
    xcrun simctl spawn "$SIMULATOR_ID" defaults write "$BUNDLE_ID" hasCompletedOnboarding -bool true
    xcrun simctl spawn "$SIMULATOR_ID" defaults write "$BUNDLE_ID" useNewUI -bool true

    # Terminate and relaunch
    xcrun simctl terminate "$SIMULATOR_ID" "$BUNDLE_ID" 2>/dev/null
    sleep 1
    xcrun simctl launch "$SIMULATOR_ID" "$BUNDLE_ID"
    sleep 3
}

capture_all_screens() {
    local lang=$1

    echo "Capturing screens for $lang..."

    # Capture current screen (should be Lab)
    capture_screenshot "$lang" "01_Lab_BlochSphere"

    echo ""
    echo "  Please manually navigate to each screen and press Enter:"
    echo ""

    read -p "  Navigate to PRESETS tab, then press Enter..."
    capture_screenshot "$lang" "02_Presets"

    read -p "  Navigate to BRIDGE tab, then press Enter..."
    capture_screenshot "$lang" "03_Bridge"

    read -p "  Navigate to MORE tab, then press Enter..."
    capture_screenshot "$lang" "04_More"

    read -p "  Navigate to ACADEMY (inside More), then press Enter..."
    capture_screenshot "$lang" "05_Academy"

    read -p "  Navigate back to LAB and tap MEASURE, then press Enter..."
    capture_screenshot "$lang" "06_Measure"

    echo "  Screenshots for $lang complete!"
}

# Main execution
echo "================================================"
echo "SwiftQuantum App Store Screenshots - All Languages"
echo "================================================"
echo ""
echo "This script will capture screenshots for:"
echo "  - English (en)"
echo "  - Korean (ko)"
echo "  - Japanese (ja)"
echo "  - Chinese Simplified (zh-Hans)"
echo "  - German (de)"
echo ""

# Check if running in interactive mode
if [ "$1" == "--auto" ]; then
    echo "Auto mode: Capturing current screen for all languages"
    for lang in "${LANGUAGES[@]}"; do
        set_language_and_restart "$lang"
        capture_screenshot "$lang" "01_Lab_BlochSphere"
    done
elif [ -n "$1" ]; then
    # Single language mode
    set_language_and_restart "$1"
    capture_all_screens "$1"
else
    # Interactive mode for all languages
    for lang in "${LANGUAGES[@]}"; do
        set_language_and_restart "$lang"
        capture_all_screens "$lang"
    done
fi

echo ""
echo "All screenshots captured!"
echo ""
echo "Screenshots saved to:"
ls -la "$BASE_DIR/"
