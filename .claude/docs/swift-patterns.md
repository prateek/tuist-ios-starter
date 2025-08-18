# Swift & TCA Development Patterns

## 📋 TCA Architecture Conventions

### **Reducer Structure**
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

### **SwiftUI View Pattern**
```swift
struct FeatureView: View {
    @Bindable var store: StoreOf<FeatureName>
    
    var body: some View {
        // UI implementation
    }
}
```

## ⚠️ Critical Closure Capture Patterns

**CRITICAL**: Swift closures cannot capture `inout` parameters like TCA's `state` parameter.

### **Problem Pattern**:
```swift
case .someAction:
    return .run { _ in
        // ❌ ERROR: Cannot capture state directly
        let value = state.someProperty
    }
```

### **Solution Pattern**:
```swift
case .someAction:
    let capturedValue = state.someProperty  // ✅ Extract before closure
    return .run { _ in
        // Use capturedValue safely in closure
        await someAsyncWork(with: capturedValue)
    }
```

### **Common Cases**:
- **AlertState message closures**: Extract dynamic values before AlertState creation
- **.run effects**: Extract state values before the closure
- **Async operations**: Capture needed state values as local variables first

## 🏗️ Dependencies Pattern

### **Definition** (in `CoreKit/Dependencies/`):
```swift
// NetworkClient.swift
import Dependencies

struct NetworkClient {
    var fetchPosts: () async throws -> [Post]
}

extension NetworkClient: DependencyKey {
    static let liveValue = NetworkClient {
        // Live implementation
    }
    
    static let testValue = NetworkClient {
        // Test data
    }
    
    static let previewValue = testValue
}

extension DependencyValues {
    var networkClient: NetworkClient {
        get { self[NetworkClient.self] }
        set { self[NetworkClient.self] = newValue }
    }
}
```

### **Usage** (in reducers):
```swift
@Dependency(\.networkClient) var networkClient

var body: some ReducerOf<Self> {
    Reduce { state, action in
        switch action {
        case .loadPosts:
            return .run { send in
                let posts = try await networkClient.fetchPosts()
                await send(.postsLoaded(posts))
            }
        }
    }
}
```

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

## 🧭 Navigation Patterns

### **Declarative Navigation**
```swift
// Use SwiftUI NavigationStack with navigationDestination
NavigationStack {
    ContentView()
        .navigationDestination(for: DestinationType.self) { destination in
            DestinationView(destination: destination)
        }
}
```

### **Tab Navigation**
```swift
// RootFeature pattern
TabView {
    HomeView(store: store.scope(state: \.home, action: \.home))
        .tabItem { Text("Home") }
    
    SettingsView(store: store.scope(state: \.settings, action: \.settings))
        .tabItem { Text("Settings") }
}
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

## 🚀 Performance Considerations

- Use `@ObservableState` for automatic observation
- Minimize state changes and effect cancellation
- Use `Equatable` conformance to prevent unnecessary updates
- Consider `removeDuplicates` for expensive observations

## 🚨 Lessons Learned: Critical Issues & Solutions

### **Swift Concurrency & Dependency Injection**

**Issue Encountered**: App crashed on launch with `EXC_BREAKPOINT (SIGTRAP)` due to Swift actor isolation violation in dependency initialization.

**Root Cause**: Using `MainActor.assumeIsolated` during static property initialization of `DependencyKey.liveValue`, which executes on background queues and violates Swift's concurrency safety rules.

#### **Problem Pattern (DO NOT USE)**:
```swift
// ❌ CRASHES: MainActor.assumeIsolated during static initialization
extension AudioService: DependencyKey {
    public static let liveValue: AudioService = {
        let manager = MainActor.assumeIsolated {
            AudioRecorderManager()  // Violates actor isolation
        }
        return AudioService(/* ... */)
    }()
}
```

**Error Symptoms**:
- App crashes immediately on launch
- Crash report shows `_dispatch_assert_queue_fail`
- Error: `swift_task_isCurrentExecutorWithFlagsImpl`
- Stack trace includes dependency resolution in ComposableArchitecture

#### **Solution Pattern (SAFE)**:
```swift
// ✅ SAFE: Use shared singleton with proper isolation
@MainActor
public class AudioRecorderManager: NSObject, ObservableObject {
    public static let shared = AudioRecorderManager()  // Safe: created on first access
    // ... implementation
}

extension AudioService: DependencyKey {
    public static let liveValue: AudioService = {
        return AudioService(
            requestPermission: {
                await AudioRecorderManager.shared.requestPermission()
            },
            startRecording: { url in
                try await MainActor.run {
                    try AudioRecorderManager.shared.startRecording(to: url)
                }
            }
            // ... other methods using MainActor.run for isolation
        )
    }()
}
```

#### **Key Principles for Swift Concurrency Safety**:

1. **NEVER use `MainActor.assumeIsolated` during static initialization**
   - Static properties initialize on arbitrary background queues
   - Use shared singletons or defer actor creation to first use

2. **Use `MainActor.run` for proper isolation in async contexts**
   - Safely execute MainActor-isolated code from any context
   - Properly handles concurrency without assumptions

3. **Prefer shared instances for actor-isolated dependencies**
   - Create `@MainActor` singletons for UI-related services
   - Initialize lazily on first access, not during static setup

4. **Debug with targeted crash analysis**
   - Look for `dispatch_assert_queue_fail` in crash reports
   - Check stack traces for dependency initialization
   - Test `tuist run App` frequently during dependency changes

#### **Testing & Validation**:
```bash
# Always test after dependency changes
tuist run App

# If crash occurs, check:
# 1. Dependencies that use @MainActor
# 2. Static initialization patterns
# 3. Actor isolation violations in crash reports
```

#### **Prevention Checklist**:
- ✅ All `@MainActor` classes use shared singletons for dependencies
- ✅ No `MainActor.assumeIsolated` in `DependencyKey.liveValue`
- ✅ Use `MainActor.run` for isolated execution in async closures
- ✅ Test app launch after any dependency changes
- ✅ Review crash reports for actor isolation violations

**Impact**: This issue caused complete app failure on launch. Proper Swift concurrency patterns are essential for stable dependency injection in modern iOS apps.

**Time to Resolution**: ~15 minutes once root cause identified. Prevention through proper patterns is critical.

## 📱 Platform Guidelines

- **Use Tuist default iOS targeting** for latest SwiftUI features
- **Use SwiftUI** over UIKit unless specific needs require it
- **Follow Apple HIG** for navigation patterns and UI design
- **Support Dynamic Type** and accessibility features
- **Test on multiple device sizes** (iPhone SE to Pro Max)