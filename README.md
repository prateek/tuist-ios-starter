# 🚀 iOS Claude Code Starter

The ultimate iOS starter template optimized for development with Claude Code and AI assistants. Built with **The Composable Architecture** and **Tuist** for modern, scalable iOS development.

## 🎯 Get Started

Create a new iOS project from this template in **under 2 minutes** with a clean, production-ready repository:

### 📋 Prerequisites
- **macOS Sonoma+** with **Xcode 15.0+**
- **Basic knowledge** of Swift, SwiftUI, and iOS development

### 🚀 Choose Your Setup Method

#### **Option 1: GitHub Template** (Recommended)
1. **Click ["Use this template"](https://github.com/prateek/tuist-ios-starter/generate)** on GitHub
2. **Name your repository** and set visibility (public/private)
3. **Clone and setup**:
   ```bash
   git clone https://github.com/yourusername/your-app-name.git
   cd your-app-name
   ./Scripts/setup.sh
   ```

#### **Option 2: GitHub CLI** (Developer-Friendly)
```bash
# Create private repository from template
gh repo create my-app --template prateek/tuist-ios-starter --private
cd my-app
./Scripts/setup.sh

# Or create public repository
gh repo create my-app --template prateek/tuist-ios-starter --public
cd my-app
./Scripts/setup.sh
```

#### **Option 3: Direct Clone** (Simple)
```bash
git clone https://github.com/prateek/tuist-ios-starter.git YourAppName
cd YourAppName
./Scripts/setup.sh
```

### 🛠 What Happens During Setup
1. **Detects template usage** and offers project customization
2. **Interactive prompts** for your project name, bundle ID, and app display name
3. **Automatically renames** all files and references to your project
4. **Removes template-specific** documentation and examples (optional)
5. **Generates clean project** ready for your development

### ▶️ Run Your New Project
```bash
make generate    # Generate Xcode project
make run        # Build and run in iPhone 16 simulator
```
Or open manually: `open YourProject.xcworkspace` and build with `⌘+R`

## ✨ Features

- 🏗 **Modern Architecture**: The Composable Architecture (TCA) for predictable state management
- 📱 **SwiftUI First**: Latest SwiftUI patterns with iOS 17+ features
- 🔧 **Tuist Integration**: Scalable project structure and dependency management
- 🤖 **AI Optimized**: Comprehensive CLAUDE.md for effective AI pair programming
- 🧪 **Testing Ready**: Complete testing setup with TCA TestStore patterns
- 🎨 **Design System**: Consistent UI components and design tokens
- ⚙️ **Developer Tools**: SwiftLint, SwiftFormat, CI/CD, and automation scripts
- ♿ **Accessibility**: Built-in accessibility support following Apple HIG

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

## 🤖 AI-Optimized Development

After setup, your project will be specifically optimized for AI-assisted development:

### 📖 AI Development Guidelines
Your project will include a customized `CLAUDE.md` file with:
- Project-specific structure navigation
- TCA architecture patterns for your codebase
- Coding conventions and best practices
- Module boundaries and dependencies
- Testing patterns and examples

### 🎯 AI-Friendly Features
- **Clear Module Separation**: Easy for AI to understand boundaries
- **Consistent Patterns**: Repetitive structures AI can follow
- **Comprehensive Examples**: Real implementations to reference (optional to keep)
- **Detailed Documentation**: Context for better code generation

### 💡 Pro Tips for AI Development
1. Always reference your project's `CLAUDE.md` when asking for changes
2. Use existing features as templates for new ones
3. Follow the established TCA patterns
4. Test new features with the provided testing utilities

## 🛠 Development Commands

After setup, your project will include these essential development commands:

### **Essential Commands**
```bash
# Quick Start (your project)
make setup              # Install dependencies and generate project
make generate          # Generate Xcode project
make run               # Build and run app in iPhone 16 simulator

# Development Cycle  
make build             # Build app (Tuist)
make test              # Run all tests 
make lint              # Run SwiftLint
make format            # Format code with SwiftFormat
```

### **Building & Running**
```bash
# Tuist Commands (Recommended)
tuist build App        # Fast, cached building
tuist run App          # Build and run in simulator
make build             # Same as tuist build App
make run               # Same as tuist run App

# Manual Commands (Explicit iPhone 16 Control)
make build-xcode       # Build with explicit iPhone 16 targeting
make run-manual        # Build + install + launch in iPhone 16 specifically
```

### **Testing**
```bash
# All Tests
make test              # Run all tests (Tuist)
tuist test             # Direct Tuist command

# Specific Modules
make test-features     # Features module only
make test-corekit      # CoreKit module only
tuist test --test-targets FeaturesTests    # Alternative syntax

# Manual Testing (iPhone 16 targeting)
make test-xcode        # Avoids iPad simulator selection
```

### **Simulator Management**
```bash
# iPhone Simulators (Fixes iPad Selection Issue)
make list-simulators   # List available iPhone simulators
make boot-iphone      # Boot iPhone 16 simulator
make reset-iphone     # Reset iPhone 16 data only

# All Simulators
make clean-simulators # Reset ALL simulators (network fix)
xcrun simctl list devices iPhone    # List iPhone simulators
xcrun simctl boot "iPhone 16"       # Boot specific simulator
```

### **Debugging & Troubleshooting**
```bash
# Network Issues
make debug-local       # Use local data (no API calls)
make diagnose-network  # Check connectivity
make reset-network     # Reset DNS/network cache

# Build Issues  
make clean            # Clean build artifacts
make tuist-clean      # Full Tuist cache clean + regenerate
tuist clean && tuist generate --no-open  # Manual clean workflow (automated)
tuist clean && tuist generate            # Manual clean workflow (opens Xcode)

# Simulator Issues
make reset-iphone     # Reset iPhone 16 simulator
make clean-simulators # Reset all simulators (network fixes)
```

## 🎯 Your Final Clean Project

After running the setup transformation, your repository will be completely clean and focused on YOUR project:

### ✅ What You Get
- **Clean README** focused on your project (not the template)
- **Renamed project files** (`YourProject.xcworkspace`, `YourProject.xcodeproj`)
- **Updated bundle identifiers** (`com.yourcompany.yourproject.*`)
- **Customized CLAUDE.md** with your project name throughout
- **Project-specific documentation** in `docs/development-workflow.md`
- **All build scripts updated** with your project names
- **Optional example code removal** (interactive choice during setup)

### ❌ What Gets Removed
- Template usage instructions (this README)
- Template-specific documentation
- Template development TODOs and contribution guidelines
- All references to "iOS Claude Code Starter"
- Example code and features (if you choose to remove them)

### 📁 Final Project Structure
```
YourProject/
├── README.md                    # Your project's README
├── CLAUDE.md                   # Your project's AI guidelines
├── CONTRIBUTING.md             # Your project's contribution guide
├── docs/
│   └── development-workflow.md # Concise team development guide
├── Tuist/Templates/            # Feature scaffolding (kept)
├── Projects/                   # Your iOS app code
├── YourProject.xcworkspace     # Your project workspace
└── YourProject.xcodeproj       # Your project file
```

The final README will include only: *Built with [iOS Claude Code Starter](https://github.com/prateek/tuist-ios-starter)*

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
# Recommended (Tuist)
make test              # Run all tests
tuist test             # Direct Tuist command

# Manual (iPhone 16 targeting)
make test-xcode        # Explicit iPhone simulator targeting
xcodebuild test -workspace iOSClaudeCodeStarter.xcworkspace -scheme iOSClaudeCodeStarter-Workspace -destination 'platform=iOS Simulator,name=iPhone 16'

# Specific Modules
make test-features     # Features module only
make test-corekit      # CoreKit module only
```

### Test Structure
- **Feature Tests**: `Projects/Features/Tests/` - TCA reducer and view tests
- **Core Tests**: `Projects/CoreKit/Tests/` - Business logic and networking tests
- **Design Tests**: `Projects/DesignSystem/Tests/` - UI component tests  
- **Test Support**: `Projects/*/Testing/` - Mocks, fixtures, and test utilities

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

### **Why Does Testing Open iPad Simulator?**

**Issue**: `tuist test` opens an iPad simulator instead of iPhone.

**Explanation**: Tuist auto-selects the first available simulator, which is often an iPad due to alphabetical ordering.

**Solutions**:
```bash
# Use explicit iPhone targeting
make test-xcode        # Forces iPhone 16 simulator

# Or use specific simulator commands
make boot-iphone      # Boot iPhone 16 first
tuist test            # Then run tests

# Check what simulators are available
make list-simulators  # See all iPhone simulators
```

## 🎨 Design System

### Colors
```swift
.foregroundColor(.textPrimary)
.backgroundColor(.backgroundPrimary)  
.accentColor(.buttonPrimary)
```

### Typography
```swift
.heading(.large)        // Major headings
.heading(.medium)       // Section headers
.body(.medium)          // Body text
.font(.buttonText)      // Button labels
```

### Spacing & Layout
```swift
.padding(.spacingS)     // 8pt
.padding(.spacingM)     // 16pt  
.padding(.spacingL)     // 24pt
.padding(.paddingM)     // EdgeInsets with 16pt all around

// New intermediate values
.padding(.spacingXS)    // 4pt - tight spacing
.padding(.spacingMS)    // 12pt - between small and medium
.padding(.spacingXL)    // 32pt - large spacing
```

### Corner Radius (New!)
```swift
.cornerRadius(.small)     // 4pt - badges, small elements
.cornerRadius(.medium)    // 8pt - buttons, cards  
.cornerRadius(.large)     // 12pt - larger components
.cornerRadius(.extraLarge) // 16pt - modals, containers
```

### Components
- `PrimaryButton`: Consistent button styling with design tokens
- `LoadingView`: Loading states with accessibility
- `LocalizedStrings`: Centralized string management for i18n readiness
- Complete design token system for consistency

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

- **iOS 18.4.0+**
- **Xcode 15.0+**
- **macOS Sonoma+**
- **Swift 5.9+**

## 🚀 CI/CD

### GitHub Actions
The project includes production-ready CI/CD workflows:

- **Code Quality**: SwiftLint + SwiftFormat validation
- **Build & Test**: Full Tuist pipeline with iPhone 16 targeting  
- **Dependabot**: Automatic dependency updates

### ⚡ Tuist Cloud Setup (Recommended)
To get **65-90% faster CI builds** through binary caching:

1. **Authenticate with Tuist**:
   ```bash
   tuist auth login
   ```

2. **Create your project** (replace with your details):
   ```bash
   tuist project create your-handle/your-project-name
   ```

3. **Generate a token**:
   ```bash
   tuist project tokens create your-handle/your-project-name > /tmp/tuist_token.txt
   ```

4. **Add to GitHub Secrets**:
   ```bash
   gh secret set TUIST_CONFIG_TOKEN < /tmp/tuist_token.txt
   rm /tmp/tuist_token.txt  # Clean up
   ```

**Benefits**: Binary caching, selective testing, bundle size tracking, and faster feedback loops.

**Without tokens**: Your project will still work perfectly, but builds from scratch on every CI run.

### Local CI Testing
```bash
make lint     # Test code quality locally
make format   # Format code for CI
make build    # Same build as CI uses
make test-xcode  # Same test targeting as CI
```

## 🤝 Contributing

1. Follow the patterns established in `CLAUDE.md`
2. Add tests for new features
3. Run `make lint` and `make format` before committing
4. Update documentation for significant changes
5. CI will validate your changes automatically

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