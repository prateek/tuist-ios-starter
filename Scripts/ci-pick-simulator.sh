#!/bin/bash
set -e

echo "🔍 Finding or creating iPhone 16 simulator..."

# Try to find existing iPhone 16 with iOS 18.x
SIMULATOR_ID=$(xcrun simctl list devices available --json | jq -r '
  .devices | to_entries[] | 
  select(.key | contains("iOS-18")) | 
  .value[] | 
  select(.name == "iPhone 16") | 
  .udid' | head -1)

if [ -z "$SIMULATOR_ID" ]; then
  echo "📱 Creating new iPhone 16 simulator..."
  # Get the latest iOS 18.x runtime
  RUNTIME=$(xcrun simctl list runtimes --json | jq -r '
    .runtimes[] | 
    select(.identifier | contains("iOS")) | 
    select(.version | startswith("18.")) | 
    .identifier' | sort -V | tail -1)
  
  if [ -z "$RUNTIME" ]; then
    echo "❌ No iOS 18.x runtime available"
    exit 1
  fi
  
  SIMULATOR_ID=$(xcrun simctl create "iPhone 16 CI" "iPhone 16" "$RUNTIME")
  echo "✅ Created simulator: $SIMULATOR_ID"
fi

echo "🚀 Booting simulator: $SIMULATOR_ID"
xcrun simctl boot "$SIMULATOR_ID" || true

echo "✅ Simulator ready: $SIMULATOR_ID"
echo "SIMULATOR_ID=$SIMULATOR_ID" >> $GITHUB_ENV