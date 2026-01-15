#!/bin/bash

# SwiftQuantum App Store Screenshots Capture Script
# Run this script to capture screenshots for App Store Connect
#
# Usage: ./capture_appstore_screenshots.sh [screenshot_name]
#
# Prerequisites:
# - iPhone 17 Pro Max simulator booted
# - App installed and running
# - Navigate to desired screen manually, then run this script

SIMULATOR_ID="3E03F05C-E596-4516-A1BF-F1306F6EA53F"
OUTPUT_DIR="/Users/eunmin/Desktop/WORK/SwiftQuantum/AppStoreAssets/Screenshots/iPhone_6.7"

# App Store sizes for iPhone 6.7" display
TARGET_WIDTH=1284
TARGET_HEIGHT=2778

capture_screenshot() {
    local name=$1
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local filename="${name:-screenshot_${timestamp}}.png"
    local temp_file="${OUTPUT_DIR}/temp_${filename}"
    local final_file="${OUTPUT_DIR}/${filename}"

    echo "Capturing screenshot: ${filename}"

    # Capture raw screenshot
    xcrun simctl io "${SIMULATOR_ID}" screenshot "${temp_file}"

    # Resize to App Store dimensions
    sips -z ${TARGET_HEIGHT} ${TARGET_WIDTH} "${temp_file}" --out "${final_file}" 2>/dev/null

    # Remove temp file
    rm -f "${temp_file}"

    echo "Saved: ${final_file}"
    sips -g pixelWidth -g pixelHeight "${final_file}"
}

# If argument provided, use it as screenshot name
if [ -n "$1" ]; then
    capture_screenshot "$1"
else
    echo ""
    echo "SwiftQuantum App Store Screenshot Capture"
    echo "=========================================="
    echo ""
    echo "Recommended screenshots to capture:"
    echo ""
    echo "1. Lab Hub - Bloch Sphere (main view)"
    echo "   ./capture_appstore_screenshots.sh 01_Lab_BlochSphere"
    echo ""
    echo "2. Presets Hub - Quantum State Presets"
    echo "   ./capture_appstore_screenshots.sh 02_Presets"
    echo ""
    echo "3. Bridge Hub - QuantumBridge Connection"
    echo "   ./capture_appstore_screenshots.sh 03_Bridge"
    echo ""
    echo "4. Academy Hub - Quantum Learning"
    echo "   ./capture_appstore_screenshots.sh 04_Academy"
    echo ""
    echo "5. Industry Hub - Enterprise Solutions"
    echo "   ./capture_appstore_screenshots.sh 05_Industry"
    echo ""
    echo "6. Measurement Results"
    echo "   ./capture_appstore_screenshots.sh 06_Measurement"
    echo ""
    echo "7. Gate Controls"
    echo "   ./capture_appstore_screenshots.sh 07_Gates"
    echo ""
    echo "8. Profile & Settings"
    echo "   ./capture_appstore_screenshots.sh 08_Profile"
    echo ""
    echo "9. Onboarding Screen"
    echo "   ./capture_appstore_screenshots.sh 09_Onboarding"
    echo ""
    echo "10. Premium Paywall"
    echo "    ./capture_appstore_screenshots.sh 10_Premium"
    echo ""
fi
