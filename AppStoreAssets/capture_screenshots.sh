#!/bin/bash

# App Store Screenshot Capture Script for SwiftQuantum
# Run this after launching the app in each simulator

ASSETS_DIR="/Users/eunmin/Desktop/WORK/SwiftQuantum/AppStoreAssets/Screenshots"

echo "=== SwiftQuantum App Store Screenshot Capture ==="
echo ""

# Function to capture screenshot for specific device
capture_screenshot() {
    local device_name="$1"
    local folder="$2"
    local screenshot_name="$3"

    # Get the booted device UDID
    local udid=$(xcrun simctl list devices | grep "$device_name" | grep "Booted" | grep -o "[A-F0-9-]\{36\}")

    if [ -n "$udid" ]; then
        xcrun simctl io "$udid" screenshot "$ASSETS_DIR/$folder/$screenshot_name"
        echo "✅ Captured: $folder/$screenshot_name"
    else
        echo "❌ Device not booted: $device_name"
    fi
}

echo "=== Device Sizes Required ==="
echo ""
echo "iPhone 6.7\" (1290x2796) - iPhone 15 Pro Max, 14 Pro Max"
echo "iPhone 6.5\" (1284x2778) - iPhone 11 Pro Max, XS Max"
echo "iPhone 5.5\" (1242x2208) - iPhone 8 Plus"
echo "iPad 12.9\" (2048x2732) - iPad Pro 12.9\""
echo "iPad 11\"   (1668x2388) - iPad Pro 11\""
echo ""

echo "=== Manual Capture Instructions ==="
echo ""
echo "1. Open Xcode → Product → Destination → Choose device"
echo "2. Run the app (Cmd + R)"
echo "3. Navigate to desired screen"
echo "4. Press Cmd + S to capture screenshot"
echo "5. Screenshots save to Desktop"
echo ""

echo "=== Available Simulators ==="
xcrun simctl list devices available | grep -E "(iPhone 15 Pro Max|iPhone 14 Pro Max|iPhone 11 Pro Max|iPhone 8 Plus|iPad Pro)"
echo ""

echo "=== Quick Capture Commands ==="
echo ""
echo "# Boot iPhone 15 Pro Max (6.7\")"
echo "xcrun simctl boot 'iPhone 15 Pro Max'"
echo ""
echo "# Capture screenshot from booted device"
echo "xcrun simctl io booted screenshot ~/Desktop/screenshot.png"
echo ""

echo "=== Recommended Screenshots ==="
echo ""
echo "01_LabHub.png     - Main quantum circuit builder"
echo "02_Presets.png    - Pre-built quantum circuits"
echo "03_Bridge.png     - Backend connection / Factory"
echo "04_Premium.png    - Premium subscription features"
echo "05_More.png       - Settings and additional options"
echo ""
