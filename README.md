# 🚀 iOS Claude Code Starter

The ultimate iOS starter template optimized for development with Claude Code and AI assistants. Built with **The Composable Architecture** and **Tuist** for modern, scalable iOS development.

## ✨ Features

- 🏗 **Modern Architecture**: The Composable Architecture (TCA) for predictable state management
- 📱 **SwiftUI First**: Latest SwiftUI patterns with iOS 17+ features
- 🔧 **Tuist Integration**: Scalable project structure and dependency management
- 🤖 **AI Optimized**: Comprehensive CLAUDE.md for effective AI pair programming
- 🧪 **Testing Ready**: Complete testing setup with TCA TestStore patterns
- 🎨 **Design System**: Consistent UI components and design tokens
- ⚙️ **Developer Tools**: SwiftLint, SwiftFormat, CI/CD, and automation scripts
- ♿ **Accessibility**: Built-in accessibility support following Apple HIG

## 🚀 Quick Start

### Option 1: Use as GitHub Template
1. Click "Use this template" on GitHub
2. Clone your new repository
3. Run the setup script:
   ```bash
   ./Scripts/setup.sh
   ```

### Option 2: Clone Directly
```bash
git clone https://github.com/prateek/tuist-ios-starter.git YourAppName
cd YourAppName
./Scripts/setup.sh
```

### Open and Run
```bash
open App.xcworkspace
```
Build and run with `⌘+R` - you're ready to develop!

## 📋 What's Included

### 🏗 Project Structure
```
├── Projects/
│   ├── App/                    # Main iOS application
│   ├── Features/               # TCA features (Home, Settings)
│   ├── CoreKit/               # Shared business logic
│   ├── DesignSystem/          # UI components & design tokens
│   └── SharedTestSupport/     # Test utilities
├── CLAUDE.md                  # AI development guidelines
├── Scripts/                   # Automation tools
└── Tuist/                     # Project configuration
```

### 🎯 Demo Features
- **Home Screen**: Demonstrates API calls, loading states, error handling
- **Settings Screen**: Shows form inputs, alerts, local state management
- **Tab Navigation**: Root coordination between features
- **Design System**: Reusable components with accessibility support

### 🧪 Testing Examples
- TCA reducer tests with TestStore
- Dependency injection and mocking
- UI component testing
- Async effect testing

## 🤖 Claude Code Development

This template is specifically optimized for AI-assisted development:

### 📖 Read CLAUDE.md First
The `CLAUDE.md` file contains essential guidelines for:
- Project structure navigation
- TCA architecture patterns
- Coding conventions and best practices
- Module boundaries and dependencies
- Testing patterns

### 🎯 AI-Friendly Features
- **Clear Module Separation**: Easy for AI to understand boundaries
- **Consistent Patterns**: Repetitive structures AI can follow
- **Comprehensive Examples**: Real implementations to reference
- **Detailed Documentation**: Context for better code generation

### 💡 Pro Tips for AI Development
1. Always reference `CLAUDE.md` when asking for changes
2. Use existing features as templates for new ones
3. Follow the established TCA patterns
4. Test new features with the provided testing utilities

## 🛠 Development Commands

```bash
# Development
make setup          # Initial project setup
make test           # Run tests
make lint           # Run SwiftLint
make format         # Format code with SwiftFormat

# Tuist
make generate       # Generate Xcode project
make tuist-clean    # Clean and regenerate project
make clean          # Clean build artifacts

# Network & Debugging
make debug-local       # Run with local data (no network)
make clean-simulators  # Reset iOS Simulators (fixes network issues)
make reset-network     # Reset network configuration
make diagnose-network  # Diagnose connectivity issues
```

## 📚 Architecture Overview

### The Composable Architecture (TCA)
This project uses TCA for:
- **Predictable State Management**: Unidirectional data flow
- **Testability**: TestStore for comprehensive testing
- **Modularity**: Clear separation of concerns
- **Side Effects**: Managed async operations

### Module Organization
- **App**: Entry point and app lifecycle
- **Features**: Independent feature modules (no cross-dependencies)
- **CoreKit**: Shared models, networking, dependencies
- **DesignSystem**: UI components and design tokens

### Key Patterns
```swift
@Reducer
struct FeatureName {
    @ObservableState
    struct State: Equatable { /* state */ }
    enum Action: Equatable { /* actions */ }
    
    @Dependency(\.dependency) var dependency
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in /* logic */ }
    }
}
```

## 🧪 Testing

### Running Tests
```bash
make test
# or
xcodebuild test -workspace App.xcworkspace -scheme App
```

### Test Structure
- **Feature Tests**: `Projects/Features/Tests/`
- **Core Tests**: `Projects/CoreKit/Tests/`
- **Test Support**: `Projects/SharedTestSupport/`

### Example Test Pattern
```swift
func testFeature() async {
    let store = TestStore(initialState: Feature.State()) {
        Feature()
    } withDependencies: {
        $0.networkClient = .mock(posts: testPosts)
    }
    
    await store.send(.action) {
        $0.property = expectedValue
    }
}
```

## 🌐 Network & Connectivity

### Quick Network Fixes

If you see "Network error" messages in the app:

```bash
make diagnose-network    # Check connectivity
make clean-simulators    # Reset simulators (most common fix)
make debug-local        # Run with offline data
```

### Network Modes

- **Default**: Uses live API (https://jsonplaceholder.typicode.com)
- **Local Data**: `DEBUG_LOCAL_DATA=1` - Uses bundled JSON (no network)
- **Custom API**: `API_BASE_URL=http://localhost:3000` - Point to local server

### Troubleshooting

For detailed network troubleshooting, see [Documentation/NetworkTroubleshooting.md](Documentation/NetworkTroubleshooting.md)

Common issues:
- **Corporate VPN/Proxy**: Use `make debug-local` or setup local mock server
- **Simulator Network**: Reset with `make clean-simulators`
- **DNS Issues**: Use `make reset-network`

## 🎨 Design System

### Colors
```swift
.foregroundColor(.textPrimary)
.backgroundColor(.backgroundPrimary)
.accentColor(.buttonPrimary)
```

### Typography
```swift
.heading(.large)
.body(.medium)
.font(.buttonText)
```

### Spacing
```swift
.padding(.spacingM)      // 16pt
.padding(.paddingL)      // 24pt all sides
```

### Components
- `PrimaryButton`: Consistent button styling
- `LoadingView`: Loading states with accessibility
- Color and typography tokens

## 🔧 Customization

### Adding New Features
1. Create `Features/NewFeature/NewFeatureFeature.swift`
2. Follow TCA patterns from existing features
3. Add tests in `Features/Tests/`
4. Wire into `RootFeature` for navigation

### Adding Dependencies
1. Add to `CoreKit/Dependencies/`
2. Implement `DependencyKey` protocol
3. Provide live/test/preview values
4. Use `@Dependency` in reducers

### Modifying Design System
1. Update tokens in `DesignSystem/`
2. Add new components in `Components/`
3. Follow accessibility guidelines
4. Include SwiftUI previews

## 📱 Requirements

- **iOS 17.0+**
- **Xcode 15.0+**
- **macOS Sonoma+**
- **Swift 5.9+**

## 🤝 Contributing

1. Follow the patterns established in `CLAUDE.md`
2. Add tests for new features
3. Update documentation for significant changes
4. Use the provided linting and formatting tools

## 📄 License

MIT License - feel free to use this template for your projects!

## 🙏 Acknowledgments

- [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) by Point-Free
- [Tuist](https://github.com/tuist/tuist) for project generation
- [Context](https://github.com/indragiek/Context) for inspiration on AI-optimized development
- The iOS development community for best practices and patterns

---

**Happy Coding with Claude! 🤖✨**

*This template is designed to maximize productivity when developing with AI assistants while maintaining high code quality and architectural standards.*