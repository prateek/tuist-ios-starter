# Contributing Guide

Thank you for your interest in contributing to the iOS Claude Code Starter! This guide will help you understand our development process and standards.

## 🚀 Getting Started

### Prerequisites
- macOS Sonoma or later
- Xcode 15.0 or later
- Basic knowledge of Swift, SwiftUI, and TCA

### Setup
1. Fork the repository
2. Clone your fork locally
3. Run the setup script: `./Scripts/setup.sh`
4. Open `App.xcworkspace` in Xcode

## 📋 Development Workflow

### Before Making Changes
1. **Read the documentation**:
   - `CLAUDE.md` for AI development guidelines
   - `Documentation/ARCHITECTURE.md` for architectural patterns
   - Existing code for established patterns

2. **Check existing issues** to avoid duplicate work

3. **Create a feature branch** from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

### Making Changes

#### Code Style
- Follow existing patterns in the codebase
- Use SwiftFormat for automatic formatting: `make format`
- Run SwiftLint to catch issues: `make lint`
- Follow TCA patterns established in `CLAUDE.md`

#### Testing Requirements
- Add tests for new features and bug fixes
- Use `TestStore` for reducer testing
- Include both success and failure test cases
- Ensure tests pass: `make test`

#### Documentation
- Update `CLAUDE.md` if adding new patterns
- Add inline documentation for complex logic
- Update README if changing setup or usage
- Include SwiftUI previews for new components

### Commit Standards

#### Commit Message Format
```
type(scope): description

optional body

optional footer
```

#### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

#### Examples
```bash
feat(home): add pull-to-refresh functionality
fix(settings): resolve theme selection bug
docs(claude): update dependency injection guidelines
test(network): add error handling test cases
```

### Pull Request Process

1. **Ensure your branch is up to date**:
   ```bash
   git checkout main
   git pull origin main
   git checkout your-branch
   git rebase main
   ```

2. **Run all checks locally**:
   ```bash
   make lint
   make format
   make test
   make generate  # Ensure Tuist files are current
   ```

3. **Create a pull request** with:
   - Clear title describing the change
   - Detailed description of what and why
   - Screenshots for UI changes
   - Reference related issues

4. **Respond to feedback** and make requested changes

## 🧪 Testing Guidelines

### Unit Tests
- Test all reducer logic with `TestStore`
- Override dependencies for predictable testing
- Test edge cases and error conditions
- Aim for high test coverage

### UI Tests
- Use SwiftUI previews for visual testing
- Test accessibility with VoiceOver
- Verify responsive layouts
- Test with different Dynamic Type sizes

### Test Organization
```
Projects/
├── Features/Tests/          # Feature-specific tests
├── CoreKit/Tests/          # Core logic tests
└── SharedTestSupport/      # Test utilities
```

## 🎨 Design System Guidelines

### Adding Components
1. Place in `DesignSystem/Components/`
2. Follow design tokens (Colors, Typography, Spacing)
3. Include accessibility support
4. Add comprehensive SwiftUI previews
5. No business logic or feature dependencies

### Design Tokens
- Use semantic color names (`.textPrimary`, `.backgroundSecondary`)
- Follow spacing scale (`.spacingS`, `.spacingM`, `.spacingL`)
- Use typography styles (`.heading(.medium)`, `.body(.large)`)

## 🏗 Architecture Guidelines

### Adding Features
1. **Create feature module**: `Features/NewFeature/`
2. **Follow TCA patterns**: State, Action, Reducer, View
3. **Add dependencies** to `CoreKit/Dependencies/`
4. **Wire into parent**: Usually `RootFeature`
5. **Add comprehensive tests**

### Module Boundaries
- **Features**: Business logic, no cross-feature imports
- **CoreKit**: Shared models and dependencies, no UI
- **DesignSystem**: UI components, no business logic
- **App**: Minimal wiring, no business logic

### Dependency Injection
```swift
// 1. Define in CoreKit
public struct NewDependency {
    public var doSomething: @Sendable () async -> Void
}

// 2. Implement DependencyKey
extension NewDependency: DependencyKey {
    public static let liveValue = NewDependency(/* implementation */)
    public static let testValue = NewDependency(/* test implementation */)
}

// 3. Extend DependencyValues
extension DependencyValues {
    public var newDependency: NewDependency {
        get { self[NewDependency.self] }
        set { self[NewDependency.self] = newValue }
    }
}

// 4. Use in reducer
@Dependency(\.newDependency) var newDependency
```

## 🔧 Tuist Guidelines

### Project Structure
- Keep module definitions clean and focused
- Use `ProjectDescriptionHelpers` for reusable patterns
- Update project after manifest changes: `make generate`

### Adding Dependencies
1. Add to `Package.swift` if external
2. Update target dependencies in `Project.swift`
3. Regenerate project: `make tuist-clean`

## 🤖 AI Development Guidelines

### For AI Contributors
- Always reference `CLAUDE.md` before making changes
- Follow established patterns in the codebase
- Test generated code thoroughly
- Maintain module boundaries
- Preserve accessibility features

### When Using AI Tools
- Verify AI-generated code compiles and runs
- Check that patterns match existing codebase
- Run tests to ensure functionality
- Review for edge cases and error handling

## 📝 Documentation Standards

### Code Documentation
- Add `// ABOUTME:` comments to file headers
- Document complex algorithms
- Explain business logic rationale
- Include usage examples for public APIs

### README Updates
- Update setup instructions for new requirements
- Add examples for new features
- Update architecture diagrams if needed
- Keep quick start guide current

## 🚫 What Not to Do

- Don't add third-party dependencies without discussion
- Don't break module boundaries
- Don't skip tests for new functionality
- Don't remove accessibility features
- Don't commit generated files without running `tuist generate`
- Don't use imperative navigation patterns

## 🏆 Recognition

Contributors who make significant improvements will be:
- Added to the Contributors section
- Credited in release notes
- Invited to help maintain the project

## 📞 Getting Help

- **Questions**: Open a discussion on GitHub
- **Bugs**: Create an issue with reproduction steps
- **Features**: Propose in an issue first
- **Architecture**: Reference `Documentation/ARCHITECTURE.md`

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for helping make iOS development with AI tools better for everyone! 🎉