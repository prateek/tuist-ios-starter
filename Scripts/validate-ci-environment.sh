#!/bin/bash

echo "🔍 GitHub Actions Environment Validation"
echo "========================================"

echo ""
echo "📱 macOS Version:"
sw_vers

echo ""
echo "🛠️  Xcode Selection:"
xcode-select -print-path

echo ""
echo "📋 Available Xcode Versions:"
ls /Applications/ | grep -i xcode || echo "No Xcode installations found"

echo ""
echo "🎯 Current Xcode Version:"
xcodebuild -version

echo ""
echo "📦 Available SDKs:"
xcodebuild -showsdks

echo ""
echo "📱 Available iOS Simulators:"
xcrun simctl list devices ios --json | jq -r '.devices | to_entries[] | "\(.key): \(.value | map(.name) | join(", "))"' 2>/dev/null || xcrun simctl list devices ios

echo ""
echo "🏗️  Swift Version:"
swift --version

echo ""
echo "🔧 Build Tools:"
echo "SwiftLint: $(swiftlint version 2>/dev/null || echo 'Not installed')"
echo "SwiftFormat: $(swiftformat --version 2>/dev/null || echo 'Not installed')"
echo "Tuist: $(tuist version 2>/dev/null || echo 'Not installed')"

echo ""
echo "💾 Environment Variables:"
echo "CI: ${CI:-'Not set'}"
echo "TUIST_CONFIG_TOKEN: ${TUIST_CONFIG_TOKEN:+'Set'}"
echo "HOMEBREW_NO_AUTO_UPDATE: ${HOMEBREW_NO_AUTO_UPDATE:-'Not set'}"

echo ""
echo "✅ Environment validation complete"