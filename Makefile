# Makefile for iOS Claude Code Starter
# Common development tasks and automation

.PHONY: help setup install generate clean test lint format tuist-clean debug-local clean-simulators reset-network diagnose-network

# Default target
help:
	@echo "iOS Claude Code Starter - Available Commands"
	@echo ""
	@echo "Setup & Build:"
	@echo "  setup        - Initial project setup (install tools, generate project)"
	@echo "  install      - Install dependencies"
	@echo "  generate     - Generate Xcode project"
	@echo "  build        - Build app (Tuist)"
	@echo "  build-xcode  - Build app (xcodebuild)"
	@echo "  clean        - Clean build artifacts"
	@echo ""
	@echo "Running:"
	@echo "  run          - Build and run app in iPhone 16 simulator"
	@echo "  run-manual   - Build and run app manually (xcodebuild + simctl)"
	@echo ""
	@echo "Testing:"
	@echo "  test         - Run all tests (Tuist)"
	@echo "  test-xcode   - Run tests (xcodebuild)"
	@echo "  test-features - Run Features module tests"
	@echo "  test-corekit - Run CoreKit module tests"
	@echo ""
	@echo "Code Quality:"
	@echo "  lint         - Run SwiftLint"
	@echo "  format       - Run SwiftFormat"
	@echo ""
	@echo "Simulators:"
	@echo "  list-simulators  - List available iPhone simulators"
	@echo "  boot-iphone     - Boot iPhone 16 simulator"
	@echo "  reset-iphone    - Reset iPhone 16 simulator data"
	@echo "  clean-simulators - Reset ALL iOS Simulators"
	@echo ""
	@echo "Network & Debugging:"
	@echo "  debug-local      - Build with local data (no network)"
	@echo "  reset-network    - Reset network configuration"
	@echo "  diagnose-network - Diagnose network connectivity"
	@echo ""
	@echo "Maintenance:"
	@echo "  tuist-clean     - Clean Tuist cache and regenerate"

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
	@xcodebuild clean -workspace iOSClaudeCodeStarter.xcworkspace -scheme iOSClaudeCodeStarter-Workspace 2>/dev/null || true

build: ## Build the app for iOS Simulator
	@echo "🔨 Building app..."
	tuist build App

build-xcode: ## Build app using xcodebuild directly
	@echo "🔨 Building app with xcodebuild..."
	xcodebuild -workspace iOSClaudeCodeStarter.xcworkspace -scheme iOSClaudeCodeStarter-Workspace -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 16' build

# Development targets
test:
	@echo "🧪 Running tests with Tuist..."
	tuist test

test-xcode: ## Run tests using xcodebuild directly
	@echo "🧪 Running tests with xcodebuild..."
	@xcodebuild test \
		-workspace iOSClaudeCodeStarter.xcworkspace \
		-scheme iOSClaudeCodeStarter-Workspace \
		-destination 'platform=iOS Simulator,name=iPhone 16' \
		| xcpretty 2>/dev/null || xcodebuild test \
		-workspace iOSClaudeCodeStarter.xcworkspace \
		-scheme iOSClaudeCodeStarter-Workspace \
		-destination 'platform=iOS Simulator,name=iPhone 16'

test-features: ## Run only Features module tests
	@echo "🧪 Running Features tests..."
	tuist test --test-targets FeaturesTests

test-corekit: ## Run only CoreKit module tests  
	@echo "🧪 Running CoreKit tests..."
	tuist test --test-targets CoreKitTests

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
debug-local: ## Build app with local data (no network requests)
	@echo "🔬 Building with local data mode..."
	DEBUG_LOCAL_DATA=1 xcodebuild -workspace iOSClaudeCodeStarter.xcworkspace -scheme iOSClaudeCodeStarter-Workspace -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 16' build

run: ## Build and run app in iPhone 16 simulator
	@echo "🚀 Building and running app in iPhone 16 simulator..."
	tuist run App

run-manual: ## Manually build and run app with full control
	@echo "🚀 Building and running app manually in iPhone 16..."
	@echo "1. Booting iPhone 16 simulator..."
	@xcrun simctl boot "iPhone 16" 2>/dev/null || echo "iPhone 16 already booted"
	@echo "2. Building app..."
	@xcodebuild -workspace iOSClaudeCodeStarter.xcworkspace -scheme iOSClaudeCodeStarter-Workspace -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 16' build
	@echo "3. Getting app path and installing..."
	@BUILD_DIR=$$(xcodebuild -workspace iOSClaudeCodeStarter.xcworkspace -scheme iOSClaudeCodeStarter-Workspace -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 16' -showBuildSettings 2>/dev/null | grep "BUILT_PRODUCTS_DIR" | head -1 | sed 's/.*= //'); \
	APP_PATH="$$BUILD_DIR/App.app"; \
	BUNDLE_ID=$$(defaults read "$$APP_PATH/Info" CFBundleIdentifier 2>/dev/null || echo "com.claudecode.starter.app"); \
	echo "Installing app: $$APP_PATH"; \
	xcrun simctl install "iPhone 16" "$$APP_PATH" && \
	echo "Launching app: $$BUNDLE_ID" && \
	xcrun simctl launch "iPhone 16" "$$BUNDLE_ID" && \
	open -a Simulator

list-simulators: ## List available iOS simulators
	@echo "📱 Available iOS Simulators:"
	@xcrun simctl list devices iPhone

boot-iphone: ## Boot iPhone 16 simulator
	@echo "🔄 Booting iPhone 16 simulator..."
	@xcrun simctl boot "iPhone 16" 2>/dev/null || echo "iPhone 16 already booted"
	@open -a Simulator

reset-iphone: ## Reset iPhone 16 simulator data
	@echo "⚠️  This will erase iPhone 16 simulator data!"
	@read -p "Continue? (y/N): " confirm && [ "$$confirm" = "y" ] || exit 1
	@xcrun simctl erase "iPhone 16"
	@echo "✅ iPhone 16 simulator reset"

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