# Development Commands & Workflows

## 🚀 Essential Development Commands

### **Quick Setup**
```bash
make setup              # Initial project setup
make generate          # Generate Xcode project  
make setup-hooks        # Install pre-commit hooks (one-time setup)
make help              # See all available commands
```

### **Building the App**
```bash
# Preferred Tuist commands (now working!)
tuist build App                    # Build using Tuist (fast, cached)
make build                         # Same as above

# Manual xcodebuild (when you need explicit control)
make build-xcode                   # Build with explicit iPhone 16 targeting
xcodebuild -workspace iOSClaudeCodeStarter.xcworkspace -scheme App -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 16' build
```

### **Running the App**
```bash
# Preferred Tuist method (now working!)
tuist run App                     # Build + run in simulator (Tuist chooses simulator)
make run                          # Same as above

# Manual workflow with explicit iPhone targeting
make boot-iphone                  # Boot iPhone 16 simulator first
make build                        # Build the app with Tuist
make run-manual                   # Install and launch in iPhone 16 specifically

# Individual simulator commands
xcrun simctl boot "iPhone 16"     # Boot iPhone 16 simulator
xcrun simctl install "iPhone 16" /path/to/App.app  # Install app
xcrun simctl launch "iPhone 16" com.claudecode.starter.app  # Launch app
```

### **Testing**
```bash
# All tests
make test                         # Run all tests (uses Tuist)
tuist test                        # Same as above (direct command)

# Specific modules  
make test-features               # Run Features module tests only
make test-corekit               # Run CoreKit module tests only
tuist test --test-targets CoreKitTests    # Alternative syntax

# Manual testing (explicit iPhone targeting)
make test-xcode                  # Run tests with xcodebuild on iPhone 16
```

### **Code Quality** (Tool Separation Strategy)
```bash
# SwiftFormat: Formatting authority (layout, braces, commas, spacing)
make format                  # Format all code with SwiftFormat
swiftformat .               # Direct SwiftFormat execution

# SwiftLint: Code quality authority (complexity, naming, TCA patterns)  
make lint                    # Check code quality with SwiftLint
swiftlint --strict          # Direct SwiftLint execution (no --fix)

# Combined workflow (recommended)
make format-lint            # Format first, then quality check
```

### **Simulator Management**
```bash
# iPhone-specific commands (fixes iPad selection issue)
make list-simulators            # List all iPhone simulators
make boot-iphone               # Boot iPhone 16 simulator
make reset-iphone              # Reset iPhone 16 data only

# General simulator commands
make clean-simulators          # Reset ALL simulators (nuclear option)
xcrun simctl list devices      # List all available simulators
xcrun simctl boot "iPhone 16"  # Boot specific simulator
```

### **Debugging & Troubleshooting**
```bash
# Network debugging
make debug-local               # Build with local data (no API calls)
make diagnose-network         # Check network connectivity  
make reset-network           # Reset DNS/network cache

# Project debugging
make tuist-clean             # Clean Tuist cache + regenerate
make clean                   # Clean build artifacts
tuist clean && tuist generate --no-open  # Full clean regeneration (automated)
tuist clean && tuist generate            # Full clean regeneration (opens Xcode)

# Tuist cache corruption (common issues)
tuist cache clean            # Clear only the cache (keeps generated projects)
rm -rf ~/Library/Caches/tuist  # Nuclear option: delete all Tuist cache
rm -rf .tuist                # Remove local cache directory
```

## 🔧 Troubleshooting Common Issues

### **"Tests open iPad simulator"**
- **Issue**: Tuist auto-selects first available simulator (often iPad)
- **Solution**: Use `make test-xcode` for explicit iPhone 16 targeting
- **Alternative**: `tuist test` with specific destination (requires Tuist config)

### **Network Errors in Simulator**
```bash
make diagnose-network       # Check connectivity first
make clean-simulators      # Reset simulators (fixes 90% of issues)
make debug-local           # Use offline mode as fallback
```

### **Build Failures**
```bash
make clean                 # Clean build artifacts
make tuist-clean          # Full Tuist regeneration
make generate             # Regenerate Xcode project
```

### **Tuist Cache Corruption**
**Symptoms**: Strange build errors, missing dependencies, outdated generated files, "Module not found" errors after adding dependencies

**Progressive Solutions** (try in order):
```bash
# Level 1: Clear cache only
tuist cache clean                    # Clear build cache (safe)

# Level 2: Full clean + regeneration  
tuist clean && tuist generate        # Clean everything and regenerate

# Level 3: Nuclear cache reset
rm -rf ~/Library/Caches/tuist        # Delete global Tuist cache
rm -rf .tuist                        # Delete local project cache
tuist generate                       # Regenerate from scratch

# Level 4: Complete reset (last resort)
make tuist-clean                     # Uses our Makefile command
rm -rf *.xcworkspace *.xcodeproj     # Remove generated files
tuist generate                       # Full regeneration
```

**When to use each**:
- **Level 1**: After dependency changes, before major builds
- **Level 2**: Weird compilation errors, after Tuist updates  
- **Level 3**: Persistent issues, corrupted cache symptoms
- **Level 4**: Nothing else works, starting fresh

## 🌐 Environment Variables

```bash
# Local development modes
DEBUG_LOCAL_DATA=1 make build      # Use bundled JSON data
API_BASE_URL=localhost:3000 make build  # Point to local API server

# Tuist configuration
TUIST_CONFIG_STATS_OPT_OUT=1       # Disable analytics (CI usage)
```