# Architecture Guide

This document outlines the architectural decisions and patterns used in the iOS Claude Code Starter template.

## Overview

The template follows a modular architecture based on The Composable Architecture (TCA) with clear separation of concerns and dependencies managed through Tuist.

## Module Architecture

### High-Level Module Diagram
```
┌─────────────┐
│     App     │ ← Entry point, minimal logic
└─────────────┘
       │
┌─────────────┐
│  Features   │ ← Business logic & UI
└─────────────┘
       │
┌─────────────┐ ┌─────────────┐
│   CoreKit   │ │ DesignSystem│ ← Shared utilities & UI
└─────────────┘ └─────────────┘
```

### Module Responsibilities

#### App Module
- **Purpose**: Application entry point and lifecycle management
- **Contains**: `@main` app structure, root store initialization
- **Dependencies**: Features, DesignSystem, ComposableArchitecture
- **Rules**: 
  - Minimal business logic
  - Only wire up the root feature
  - Handle app-level configuration

#### Features Module
- **Purpose**: All business logic and feature-specific UI
- **Contains**: TCA reducers, views, feature coordination
- **Dependencies**: CoreKit, DesignSystem, ComposableArchitecture
- **Rules**:
  - Features should not depend on other features directly
  - Communication between features through parent coordinators
  - Each feature should be testable in isolation

#### CoreKit Module
- **Purpose**: Shared business logic and utilities
- **Contains**: Models, networking, dependency injection, utilities
- **Dependencies**: ComposableArchitecture (for Dependencies framework)
- **Rules**:
  - No UI code
  - No feature-specific logic
  - Pure business logic and data structures

#### DesignSystem Module
- **Purpose**: Reusable UI components and design tokens
- **Contains**: Components, colors, typography, spacing, assets
- **Dependencies**: None (SwiftUI only)
- **Rules**:
  - No business logic
  - No feature-specific components
  - Focus on reusability and consistency

## TCA Architecture Patterns

### State Management
```swift
@Reducer
struct FeatureReducer {
    @ObservableState
    struct State: Equatable {
        // All feature state in one place
        var isLoading = false
        var items: [Item] = []
        var error: String?
    }
    
    enum Action: Equatable {
        // Exhaustive list of all possible actions
        case loadItems
        case itemsResponse(Result<[Item], Error>)
    }
}
```

### Side Effects
- Use `Effect.run` for async operations
- Cancel effects when appropriate
- Handle errors gracefully
- Maintain referential transparency

### Navigation
- State-driven navigation using SwiftUI's navigation APIs
- Navigation state managed in parent reducers
- Use `@Presents` for modal presentations
- Avoid imperative navigation patterns

## Dependency Injection

### Pattern
```swift
public struct NetworkClient: Sendable {
    public var fetchItems: @Sendable () async throws -> [Item]
}

extension NetworkClient: DependencyKey {
    public static let liveValue = NetworkClient(/* live implementation */)
    public static let testValue = NetworkClient(/* test implementation */)
    public static let previewValue = testValue
}

extension DependencyValues {
    public var networkClient: NetworkClient {
        get { self[NetworkClient.self] }
        set { self[NetworkClient.self] = newValue }
    }
}
```

### Usage in Reducers
```swift
@Reducer
struct FeatureReducer {
    @Dependency(\.networkClient) var networkClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            case .loadItems:
                return .run { send in
                    let items = try await networkClient.fetchItems()
                    await send(.itemsResponse(.success(items)))
                }
        }
    }
}
```

## Testing Strategy

### Reducer Testing
- Use `TestStore` for comprehensive state testing
- Override dependencies for predictable testing
- Test both success and failure paths
- Verify all state mutations

### UI Testing
- Use SwiftUI previews with different states
- Test accessibility with VoiceOver
- Verify responsive layouts
- Test with different Dynamic Type sizes

### Integration Testing
- Test feature integration through parent reducers
- Verify navigation flows
- Test dependency injection scenarios

## Performance Considerations

### State Observation
- Use `@ObservableState` for automatic observation
- Minimize unnecessary state changes
- Use `Equatable` conformance effectively

### Effect Management
- Cancel effects when features are dismissed
- Use appropriate effect lifetimes
- Avoid retain cycles in effects

### Memory Management
- Keep state minimal and focused
- Use value types where possible
- Be mindful of closure captures

## Code Organization Guidelines

### File Organization
```
Feature/
├── FeatureFeature.swift     # Main feature implementation
├── FeatureView.swift        # If view is complex
└── Supporting/              # Supporting types if needed
```

### Naming Conventions
- **Reducers**: `FeatureNameFeature`
- **Views**: `FeatureNameView`
- **Actions**: Descriptive verbs (`buttonTapped`, `dataLoaded`)
- **Dependencies**: Descriptive nouns (`networkClient`, `userDefaults`)

### Import Organization
1. Foundation/SwiftUI
2. Third-party frameworks
3. Internal modules (CoreKit, DesignSystem)
4. ComposableArchitecture (last)

## Scalability Patterns

### Adding New Features
1. Create feature in Features module
2. Define clear state and actions
3. Implement business logic in reducer
4. Create view following design system
5. Add comprehensive tests
6. Wire into parent feature

### Module Splitting
When modules become large:
1. Split by feature domain
2. Maintain clear interfaces
3. Update dependency graph
4. Preserve testing isolation

### Microfeatures
For very large apps, consider:
- One module per feature
- Shared interface protocols
- Feature flag integration
- Independent deployment

## Common Patterns

### Loading States
```swift
struct State {
    var isLoading = false
    var data: [Item] = []
    var error: String?
}

// In reducer:
case .load:
    state.isLoading = true
    state.error = nil
    return .run { /* async work */ }

case .loadResponse(.success(let data)):
    state.isLoading = false
    state.data = data
    return .none

case .loadResponse(.failure(let error)):
    state.isLoading = false
    state.error = error.localizedDescription
    return .none
```

### Form Handling
```swift
struct State {
    @BindingState var formData = FormData()
    var isSubmitting = false
}

enum Action: BindableAction {
    case binding(BindingAction<State>)
    case submitForm
}

var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { /* handle other actions */ }
}
```

## Decision Records

### Why TCA?
- Predictable state management
- Excellent testability
- Side effect management
- Type safety
- Debugging capabilities

### Why Tuist?
- Modular project structure
- Dependency management
- Build performance
- Team scalability
- Configuration as code

### Why Module Structure?
- Clear separation of concerns
- Independent testing
- Reduced compile times
- Team collaboration
- Feature isolation

This architecture provides a solid foundation for scalable iOS development while maintaining clarity for AI-assisted development.