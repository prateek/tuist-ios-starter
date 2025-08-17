# iOS Claude Code Starter - AI Development Guide

This project is optimized for development with Claude Code and other AI assistants. Follow these guidelines to ensure high-quality, consistent code generation.

## 🎯 Project Goals & Priorities

1. **Ship working code** that compiles and runs in the current targets
2. **Follow TCA patterns** used consistently throughout this codebase
3. **Maintain modularity** - keep features isolated and dependencies clear
4. **Prioritize accessibility** and follow Apple Human Interface Guidelines
5. **Use modern Swift/SwiftUI** patterns (async/await, Dependencies framework)

## 🗺 Codebase Map

### **App Module** (`Projects/App/`)
- Entry point with `@main` app structure
- Minimal - only contains app lifecycle and root store setup
- **Dependencies**: Features, DesignSystem, ComposableArchitecture

### **Features Module** (`Projects/Features/Sources/`)
- Contains all feature reducers and views
- **Structure**: Each feature in its own folder (Home/, Settings/, Root/)
- **Pattern**: One file per feature unless size warrants splitting
- **Dependencies**: CoreKit, DesignSystem, ComposableArchitecture
- **Rule**: Features should NOT import other features directly

### **CoreKit Module** (`Projects/CoreKit/Sources/`)
- Shared business logic, models, and dependencies
- **Models/**: Data structures (Post, NetworkError, etc.)
- **Dependencies/**: Dependency injection setup (NetworkClient, etc.)
- **No UI code** - purely business logic and data

### **DesignSystem Module** (`Projects/DesignSystem/Sources/`)
- Visual components, colors, typography, spacing
- **Components/**: Reusable UI components (PrimaryButton, LoadingView)
- **Design tokens**: Colors, Typography, Spacing
- **Rule**: No business logic or feature-specific code

## 🏗 TMA (The Modular Architecture) Implementation

This project follows **Tuist's TMA 3-target pattern** for optimal AI-first development:

### **Target Structure (per module)**
```
ModuleName/
├── Sources/           # Main implementation
├── Tests/            # Unit & integration tests  
└── Testing/          # Mocks, fixtures, test utilities
```

### **Testing Modules** (`Projects/*/Testing/Sources/`)
- **CoreKitTesting**: Mock NetworkClient, TestData fixtures
- **FeaturesTesting**: TCA test stores, mock states, testing helpers
- **DesignSystemTesting**: Component mocks, preview helpers

### **AI-First Benefits**
- **Clear boundaries**: AI can easily understand module responsibilities
- **Test utilities**: Centralized mocks and fixtures for consistent testing
- **Scalable patterns**: Add features without breaking existing structure
- **Template automation**: Use `tuist scaffold Feature --name NewFeature`

### **Creating New Features**
```bash
# Generate complete feature with TMA pattern
tuist scaffold Feature --name YourFeature

# This creates:
# - Projects/Features/Sources/YourFeature/YourFeatureFeature.swift
# - Projects/Features/Tests/YourFeatureFeatureTests.swift  
# - Projects/Features/Testing/Sources/YourFeatureTesting.swift
```

### **Testing Strategy with `tuist test`**
```bash
tuist test                          # Run all tests
tuist test --test-targets CoreKitTests  # Run specific module tests
tuist test --no-binary-cache          # Force clean test run
tuist test --selective-testing        # Intelligent test selection
```

## 📋 Architecture Conventions

### **TCA Patterns**
```swift
@Reducer
struct FeatureName {
    @ObservableState
    struct State: Equatable {
        // State properties here
    }
    
    enum Action: Equatable {
        // Actions here - use descriptive names
    }
    
    @Dependency(\.dependencyName) var dependency
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // Handle actions here
            }
        }
    }
}
```

### **SwiftUI Views**
```swift
struct FeatureView: View {
    @Bindable var store: StoreOf<FeatureName>
    
    var body: some View {
        // UI implementation
    }
}
```

### **Dependencies**
- Define in `CoreKit/Dependencies/`
- Use `DependencyKey` protocol for registration
- Provide `liveValue`, `testValue`, and `previewValue`
- Access via `@Dependency(\.dependencyName)`

### **Navigation**
- Use SwiftUI `NavigationStack` with `navigationDestination`
- Avoid imperative navigation - use declarative state-driven navigation
- For tabs, use `TabView` as shown in `RootFeature`

## 🔧 How to Make Changes

### **Adding a New Feature (TMA Pattern)**
1. **Generate with template**: `tuist scaffold Feature --name NewFeature`
2. **Auto-generated files**:
   - `Features/Sources/NewFeature/NewFeatureFeature.swift` (implementation)
   - `Features/Tests/NewFeatureFeatureTests.swift` (unit tests)
   - `Features/Testing/Sources/NewFeatureTesting.swift` (test utilities)
3. **Add dependencies** to `CoreKit/Dependencies/` if needed
4. **Wire into parent** (usually `RootFeature`)
5. **Customize tests** using generated test utilities and mocks

### **Adding UI Components**
1. Place in `DesignSystem/Components/`
2. Follow design system tokens (Colors, Typography, Spacing)
3. Include accessibility support
4. Add SwiftUI previews
5. Ensure no dependencies on Features module

### **Adding Dependencies**
1. Create client struct in `CoreKit/Dependencies/`
2. Implement `DependencyKey` with live/test/preview values
3. Extend `DependencyValues` to expose the dependency
4. Use `@Dependency` in reducers that need it

### **Testing**
- Use `TestStore` for reducer testing
- Override dependencies in tests: `withDependencies: { $0.dependency = mockValue }`
- Test both success and failure paths
- Include accessibility testing for UI components

## 🎨 Design System Usage

### **Colors**
```swift
.foregroundColor(.textPrimary)        // Primary text
.foregroundColor(.textSecondary)      // Secondary text  
.backgroundColor(.backgroundPrimary)   // Main background
.backgroundColor(.buttonPrimary)       // Primary buttons
```

### **Typography**
```swift
.heading(.large)    // For major headings
.heading(.medium)   // For section headers
.body(.medium)      // For body text
.font(.buttonText)  // For button labels
```

### **Spacing**
```swift
.padding(.spacingS)     // 8pt
.padding(.spacingM)     // 16pt  
.padding(.spacingL)     // 24pt
.padding(.paddingM)     // EdgeInsets with 16pt all around
```

## ⚠️ Important Boundaries

### **DO**
- ✅ Keep features modular and independent
- ✅ Use dependency injection for testability
- ✅ Follow Apple HIG and accessibility guidelines
- ✅ Use SF Symbols for icons
- ✅ Make SwiftUI previews that work without network calls
- ✅ Write tests for new reducers and components
- ✅ Use descriptive action and state property names

### **DON'T**
- ❌ Add new third-party dependencies without explicit instruction
- ❌ Import Features module from other Features
- ❌ Put business logic in DesignSystem
- ❌ Use imperative navigation patterns
- ❌ Hardcode strings - consider localization needs
- ❌ Skip accessibility considerations
- ❌ Leave preview providers that crash or don't work

## 🔄 Development Workflow

### **Before Making Changes**
1. Understand which module the change belongs in
2. Check if similar patterns exist in the codebase
3. Consider dependencies and module boundaries

### **While Implementing**
1. Follow existing naming conventions
2. Add appropriate accessibility support
3. Ensure code compiles after each change
4. Add SwiftUI previews for new UI components

### **After Implementation**
1. Add or update tests as needed
2. Verify accessibility with VoiceOver
3. Test on different device sizes if UI-related
4. Ensure previews work correctly

## 🧪 Testing Guidelines (TMA Pattern)

### **Using Testing Modules**
```swift
// Use centralized test utilities from Testing modules
func testFeatureAction() async {
    let store = FeatureName.testStore(
        initialState: MockStates.featureLoading,
        networkClient: NetworkClient.mockSuccess
    )
    
    await store.send(.action) {
        $0.property = expectedValue
    }
}
```

### **TMA Testing Structure**
- **Tests/**: Unit and integration tests using Testing module utilities
- **Testing/**: Centralized mocks, fixtures, and test helpers
- **Mock Clients**: Use `NetworkClient.mockSuccess`, `.mockFailure`, `.mockEmpty`
- **Test Data**: Access via `TestData.samplePosts`, `TestData.longPost`
- **Mock States**: Use `MockStates.homeLoading`, `.homeWithError`, etc.

### **Primary Testing Command**
```bash
tuist test                    # Run all tests with caching & selective testing
tuist test --test-targets CoreKitTests  # Run specific module
tuist test --no-binary-cache           # Force clean test run
```

## 🚀 Essential Development Commands

### **Quick Setup**
```bash
make setup              # Initial project setup
make generate          # Generate Xcode project  
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
```

### **Code Quality**
```bash
make lint                    # Run SwiftLint
make format                  # Run SwiftFormat  
swiftlint --fix             # Auto-fix SwiftLint issues
```

### **Environment Variables**
```bash
# Local development modes
DEBUG_LOCAL_DATA=1 make build      # Use bundled JSON data
API_BASE_URL=localhost:3000 make build  # Point to local API server
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

## 🚀 CI/CD & GitHub Actions

### **GitHub Actions Workflows**
The project includes modern CI/CD workflows in `.github/workflows/`:

- **Code Quality Job**: SwiftLint + SwiftFormat validation
- **Build & Test Job**: Full Tuist build + test pipeline with iPhone 16 targeting
- **Dependabot**: Automatic dependency updates for Swift packages and GitHub Actions

### **CI Commands Used**
```bash
# CI builds use these exact commands
tuist install              # Install dependencies
tuist generate --no-open   # Generate project (automated/CI)
tuist generate             # Generate project (opens Xcode)
tuist build App           # Build with caching
xcodebuild test -workspace iOSClaudeCodeStarter.xcworkspace -scheme iOSClaudeCodeStarter-Workspace -destination 'platform=iOS Simulator,name=iPhone 16'
```

### **Local CI Testing**
```bash
# Test CI commands locally
make lint                 # Same as CI code quality check
make format               # Format code like CI expects
make build                # Same build command as CI
make test-xcode           # Same test targeting as CI
```

### **UI Tests**
- Use SwiftUI previews for visual testing
- Leverage DesignSystemTesting utilities for consistent preview data
- Test different states using MockStates from Testing modules
- Verify accessibility labels and traits

## 🌐 Network & Connectivity

### **Network Resilience**
The NetworkClient includes production-ready patterns:
- **Optimized timeouts**: 15s request, 30s resource (vs default 60s)
- **Retry logic**: 2 attempts with exponential backoff
- **Better error messages**: User-friendly timeout and connectivity messages
- **Environment support**: `API_BASE_URL` for custom endpoints

### **Development Modes**
- **Normal**: Uses live API (https://jsonplaceholder.typicode.com)
- **Local Data**: `DEBUG_LOCAL_DATA=1` for offline development
- **Custom API**: `API_BASE_URL=localhost:3000` for mock servers

### **Troubleshooting Network Issues**
```bash
make diagnose-network    # Check connectivity
make clean-simulators    # Reset simulators (common fix)
make debug-local        # Use bundled data
```

See `Documentation/NetworkTroubleshooting.md` for detailed guidance.

## 🚀 Performance Considerations

- Use `@ObservableState` for automatic observation
- Minimize state changes and effect cancellation
- Use `Equatable` conformance to prevent unnecessary updates
- Consider `removeDuplicates` for expensive observations

## 📱 Platform Guidelines

- **Target iOS 17.0+** for latest SwiftUI features
- **Use SwiftUI** over UIKit unless specific needs require it
- **Follow Apple HIG** for navigation patterns and UI design
- **Support Dynamic Type** and accessibility features
- **Test on multiple device sizes** (iPhone SE to Pro Max)

---

This guide ensures consistent, high-quality code generation. When in doubt, follow existing patterns in the codebase and prioritize clarity and maintainability.