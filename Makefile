# Makefile for iOS Claude Code Starter
# Common development tasks and automation

.PHONY: help setup install generate clean test lint format tuist-clean debug-local clean-simulators reset-network diagnose-network

# Default target
help:
	@echo "iOS Claude Code Starter - Available Commands"
	@echo ""
	@echo "Setup & Build:"
	@echo "  setup     - Initial project setup (install tools, generate project)"
	@echo "  install   - Install dependencies"
	@echo "  generate  - Generate Xcode project"
	@echo "  clean     - Clean build artifacts"
	@echo ""
	@echo "Development:"
	@echo "  test      - Run tests"
	@echo "  lint      - Run SwiftLint"
	@echo "  format    - Run SwiftFormat"
	@echo ""
	@echo "Network & Debugging:"
	@echo "  debug-local       - Run app with local data (no network)"
	@echo "  clean-simulators  - Reset all iOS Simulators"
	@echo "  reset-network     - Reset network configuration"
	@echo "  diagnose-network  - Diagnose network connectivity"
	@echo ""
	@echo "Tuist:"
	@echo "  tuist-clean - Clean Tuist cache and regenerate"

# Setup & Build targets
setup:
	@echo "🚀 Setting up project..."
	@Scripts/setup.sh

install:
	@echo "📦 Installing dependencies..."
	@tuist install

generate:
	@echo "🔨 Generating Xcode project..."
	@tuist generate

clean:
	@echo "🧹 Cleaning build artifacts..."
	@rm -rf Derived
	@rm -rf .build
	@xcodebuild clean -workspace App.xcworkspace -scheme App 2>/dev/null || true

build: ## Build the app for iOS Simulator
	@echo "🔨 Building app..."
	xcodebuild -workspace iOSClaudeCodeStarter.xcworkspace -scheme App -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 16' build

# Development targets
test:
	@echo "🧪 Running tests..."
	@xcodebuild test \
		-workspace App.xcworkspace \
		-scheme App \
		-destination 'platform=iOS Simulator,name=iPhone 15' \
		| xcpretty 2>/dev/null || xcodebuild test \
		-workspace App.xcworkspace \
		-scheme App \
		-destination 'platform=iOS Simulator,name=iPhone 15'

lint:
	@echo "🔍 Running SwiftLint..."
	@if command -v swiftlint >/dev/null 2>&1; then \
		swiftlint; \
	else \
		echo "⚠️  SwiftLint not installed. Install with: brew install swiftlint"; \
	fi

format:
	@echo "✨ Formatting code..."
	@if command -v swiftformat >/dev/null 2>&1; then \
		swiftformat .; \
	else \
		echo "⚠️  SwiftFormat not installed. Install with: brew install swiftformat"; \
	fi

# Tuist targets
tuist-clean:
	@echo "🧹 Cleaning Tuist cache and regenerating..."
	@tuist clean
	@tuist install
	@tuist generate

# Network & Debugging targets
debug-local: ## Run app with local data (no network requests)
	@echo "🔬 Building with local data mode..."
	DEBUG_LOCAL_DATA=1 xcodebuild -workspace iOSClaudeCodeStarter.xcworkspace -scheme App -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 16' build

clean-simulators: ## Reset all iOS Simulators (fixes network issues)
	@echo "⚠️  This will erase ALL iOS Simulators and their data!"
	@read -p "Continue? (y/N): " confirm && [ "$$confirm" = "y" ] || exit 1
	@echo "🔄 Resetting simulators..."
	xcrun simctl erase all
	@echo "✅ All simulators reset"

reset-network: ## Reset network configuration
	@echo "🌐 Resetting network configuration..."
	sudo dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
	@echo "✅ Network cache cleared"

diagnose-network: ## Diagnose network connectivity issues
	@echo "🔍 Network connectivity diagnosis:"
	@echo "1. Testing external API from host..."
	@curl -s -o /dev/null -w "Status: %{http_code}, Time: %{time_total}s\n" https://jsonplaceholder.typicode.com/posts || echo "❌ External API unreachable"
	@echo "2. Testing DNS resolution..."
	@nslookup jsonplaceholder.typicode.com || echo "❌ DNS resolution failed"
	@echo "3. Available simulators:"
	@xcrun simctl list devices | grep "iPhone" | head -5

# Check if tools are installed
check-tools:
	@echo "🔧 Checking required tools..."
	@command -v tuist >/dev/null 2>&1 || (echo "❌ Tuist not found. Run 'make setup' first." && exit 1)
	@command -v xcodebuild >/dev/null 2>&1 || (echo "❌ Xcode not found." && exit 1)
	@echo "✅ All required tools are available"