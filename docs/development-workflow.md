# Development Workflow Guide

This guide outlines the development patterns and workflows for this project. Follow these conventions to maintain consistency and enable effective AI-assisted development.

## 🏗 Project Architecture

### Module Structure
- **App**: Entry point and app lifecycle management only
- **Features**: Independent business logic modules (no cross-feature imports)
- **CoreKit**: Shared models, networking, and dependencies
- **DesignSystem**: UI components, design tokens, and styling

### Module Boundaries
```
✅ Allowed Dependencies:
Features → CoreKit, DesignSystem
CoreKit → (external packages only)
DesignSystem → (no dependencies)
App → Features, DesignSystem

❌ Forbidden:
Features → Features (no cross-feature imports)
Any module → App
```

## 🧩 Adding New Features

### 1. Create Feature Module
Use Tuist scaffolding for consistency:
```bash
tuist scaffold feature --name YourFeature
```

This creates:
- `Projects/Features/Sources/YourFeature/YourFeatureFeature.swift`
- `Projects/Features/Tests/YourFeatureFeatureTests.swift`
- `Projects/Features/Testing/Sources/YourFeatureTesting.swift`

### 2. TCA Pattern Structure
Every feature follows this pattern:
```swift
@Reducer
public struct YourFeature {
    @ObservableState
    public struct State: Equatable {
        // State properties
    }
    
    public enum Action: Equatable {
        // Use descriptive action names
        case viewDidAppear
        case buttonTapped
        case dataResponse(Result<Data, Error>)
    }
    
    @Dependency(\.yourDependency) var yourDependency
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            // Handle actions here
        }
    }
}
```

### 3. Naming Conventions
- **Features**: PascalCase with "Feature" suffix (`PaymentFeature`)
- **Actions**: Descriptive verbs (`saveButtonTapped`, `networkResponseReceived`)
- **State properties**: Clear, descriptive names (`isLoading`, `selectedItems`)
- **Dependencies**: Noun describing the service (`networkClient`, `databaseManager`)

## 🔗 Dependency Management

### Adding New Dependencies
1. **Define in CoreKit**: Create client struct in `CoreKit/Dependencies/`
2. **Implement DependencyKey**: Provide live, test, and preview values
3. **Extend DependencyValues**: Make dependency accessible
4. **Use in reducers**: Access via `@Dependency(\.dependencyName)`

Example:
```swift
// 1. CoreKit/Dependencies/YourClient.swift
public struct YourClient {
    public var fetchData: () async throws -> [Data]
}

// 2. Implement DependencyKey
extension YourClient: DependencyKey {
    public static let liveValue = YourClient(
        fetchData: { /* live implementation */ }
    )
    public static let testValue = YourClient(
        fetchData: { /* test implementation */ }
    )
}

// 3. Extend DependencyValues
extension DependencyValues {
    public var yourClient: YourClient {
        get { self[YourClient.self] }
        set { self[YourClient.self] = newValue }
    }
}

// 4. Use in reducer
@Dependency(\.yourClient) var yourClient
```

## 🧪 Testing Requirements

### Test Structure
Each feature must have:
- **Unit tests** for all reducer logic
- **Success and failure paths** tested
- **Dependency injection** with test values
- **Edge cases** and error conditions covered

### Testing Pattern
```swift
func testFeatureAction() async {
    let store = TestStore(initialState: YourFeature.State()) {
        YourFeature()
    } withDependencies: {
        $0.yourClient = YourClient(
            fetchData: { mockData }
        )
    }
    
    await store.send(.action) {
        $0.expectedStateChange = newValue
    }
}
```

### Test Organization
- Use `TestStore` for all reducer testing
- Override dependencies for predictable testing
- Test both success and failure scenarios
- Include accessibility testing for UI components

## 🎨 Design System Usage

### Design Tokens
Always use design system tokens for consistency:

```swift
// Colors
.foregroundColor(.textPrimary)
.backgroundColor(.backgroundSecondary)

// Typography
.heading(.large)     // Major headings
.body(.medium)       // Body text
.font(.buttonText)   // Button labels

// Spacing
.padding(.spacingM)  // 16pt padding
.padding(.paddingL)  // 24pt all-around padding

// Corner Radius
.cornerRadius(.medium) // 8pt radius
```

### Component Usage
- Use `PrimaryButton` for primary actions
- Use `LoadingView` for loading states
- Follow accessibility guidelines in all components

## 🚀 Build & Development

### Essential Commands
```bash
# Development cycle
make generate       # Generate Xcode project after manifest changes (--no-open)
make build         # Build app with Tuist (fast, cached)
make test          # Run all tests
make lint          # Run SwiftLint
make format        # Format code with SwiftFormat

# Manual project generation
tuist generate --no-open  # Generate without opening Xcode (automation/scripts)
tuist generate            # Generate and open in Xcode (manual development)

# Specific testing
make test-features # Test Features module only
make test-corekit  # Test CoreKit module only
```

### Before Committing
1. **Run linting**: `make lint` (must pass)
2. **Run tests**: `make test` (must pass)
3. **Format code**: `make format`
4. **Test in simulator**: Verify UI changes work correctly

## 🔄 CI/CD Guidelines

### Required Checks
- All tests must pass
- SwiftLint must pass with no violations
- Code must be formatted with SwiftFormat
- Project must build successfully

### Pull Request Requirements
- Descriptive title and description
- All CI checks passing
- Screenshots for UI changes
- Tests for new functionality

## 🤖 AI Development Guidelines

### Working with AI Assistants
1. **Reference this guide** when asking for code changes
2. **Use existing patterns** as templates for new features
3. **Follow established conventions** in naming and structure
4. **Test AI-generated code** thoroughly before committing

### Effective AI Prompts
- Be specific about which module the change belongs in
- Reference existing similar features for context
- Specify testing requirements upfront
- Ask for accessibility considerations

## 📋 Code Review Checklist

Before approving pull requests, verify:
- [ ] Follows established TCA patterns
- [ ] Respects module boundaries
- [ ] Includes comprehensive tests
- [ ] Uses design system components and tokens
- [ ] Follows naming conventions
- [ ] Includes accessibility support
- [ ] Has proper error handling
- [ ] Documentation is updated if needed

## 🚫 Common Pitfalls

### Don't:
- Import Features modules from other Features
- Put business logic in DesignSystem
- Skip testing for new functionality
- Use imperative navigation patterns
- Hardcode strings (consider localization)
- Break accessibility with custom components

### Do:
- Keep features modular and independent
- Use dependency injection for testability
- Follow Apple HIG and accessibility guidelines
- Use descriptive action and state property names
- Include SwiftUI previews for new components

---

This guide ensures consistent, maintainable code that works well with AI development tools. When in doubt, follow existing patterns in the codebase.