#!/bin/bash

# ABOUTME: Development environment setup script
# ABOUTME: Installs required tools and generates the Xcode project

set -e

echo "🚀 Setting up iOS Claude Code Starter development environment..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script requires macOS"
    exit 1
fi

# Install Tuist if not present
if ! command -v tuist &> /dev/null; then
    echo "📦 Installing Tuist..."
    curl -Ls https://install.tuist.io | bash
else
    echo "✅ Tuist is already installed"
fi

# Generate Xcode project
echo "🔨 Generating Xcode project..."
tuist install
tuist generate

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Open the generated project: open App.xcworkspace"
echo "2. Build and run the app (⌘+R)"
echo "3. Start developing with Claude Code!"
echo ""
echo "📖 Read CLAUDE.md for AI development guidelines"
echo "📖 Read README.md for project overview"