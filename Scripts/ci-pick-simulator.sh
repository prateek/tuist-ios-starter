#!/bin/bash
set -e

echo "🔍 Finding reliable iPhone 16 simulator..."

# Use simple, reliable approach - find any iPhone 16 with iOS 18.x
SIMULATOR_ID=$(xcrun simctl list devices --json | jq -r '
  .devices | to_entries[] | 
  select(.key | contains("iOS-18")) | 
  .value[] | 
  select(.name == "iPhone 16" and .state == "Shutdown") | 
  .udid' | head -1)

if [ -z "$SIMULATOR_ID" ]; then
  echo "📱 No shutdown iPhone 16 found, trying booted ones..."
  SIMULATOR_ID=$(xcrun simctl list devices --json | jq -r '
    .devices | to_entries[] | 
    select(.key | contains("iOS-18")) | 
    .value[] | 
    select(.name == "iPhone 16") | 
    .udid' | head -1)
fi

if [ -z "$SIMULATOR_ID" ]; then
  echo "❌ No iPhone 16 simulators found"
  xcrun simctl list devices | grep "iPhone 16" || echo "No iPhone 16 devices at all"
  exit 1
fi

echo "🚀 Selected simulator: $SIMULATOR_ID"
echo "🔧 Booting simulator..."
xcrun simctl boot "$SIMULATOR_ID" || echo "Simulator already booted or boot failed"

# Verify simulator is actually available
echo "✅ Verifying simulator availability..."
xcrun simctl list devices | grep "$SIMULATOR_ID" || echo "Simulator not found in list"

echo "✅ Simulator ready: $SIMULATOR_ID"
echo "SIMULATOR_ID=$SIMULATOR_ID" >> "${GITHUB_ENV:-/dev/null}"