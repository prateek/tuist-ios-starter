# Tuist Architecture & TMA Implementation

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

## 🗺 Module Architecture

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

## 🔄 Adding Components

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

## 🔧 Cache Management

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