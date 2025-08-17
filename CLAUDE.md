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

## 🚀 Quick Start

### **Essential Commands**
```bash
make setup              # Initial project setup
make generate          # Generate Xcode project
make format-lint       # Format code + quality check
make build             # Build app with Tuist
make run               # Build and run in simulator
make test              # Run all tests
```

### **Code Quality Workflow**
```bash
make format            # SwiftFormat: ALL formatting authority
make lint              # SwiftLint: Code quality only
make format-lint       # Combined workflow (recommended)
```

## 📚 Detailed Documentation

For comprehensive guidance on specific topics, see:

- **@.claude/docs/tuist-architecture.md** - TMA patterns, module structure, scaffolding
- **@.claude/docs/swift-patterns.md** - TCA conventions, closure patterns, design system
- **@.claude/docs/testing-infrastructure.md** - Critical testing patterns, namespace safety
- **@.claude/docs/code-quality.md** - SwiftFormat/SwiftLint tool separation strategy
- **@.claude/docs/development-commands.md** - All commands, troubleshooting, workflows
- **@.claude/docs/ci-cd.md** - GitHub Actions, pre-commit hooks, act validation
- **@.claude/docs/mcp-integration.md** - MCP servers, AI tools, GitHub integration

## ⚡ Critical Reminders

### **Tool Separation**
- **SwiftFormat**: ALL formatting (braces, commas, spacing)
- **SwiftLint**: ONLY code quality (complexity, naming, patterns)
- **No overlap**: Eliminates infinite formatting cycles

### **Testing Safety**
- Use domain-specific test type names (not generic TestData, Helpers)
- Add timeouts to ALL async test assertions
- Always call `store.finish()` in TCA tests
- Mock ALL dependencies in effects

### **Module Boundaries**
- Features should NOT import other Features
- CoreKit should NOT import UI frameworks
- DesignSystem should remain UI-only

### **AI Development**
- Use `tuist scaffold` for new features
- Follow existing patterns in the codebase
- Prioritize clarity and maintainability
- Test on multiple device sizes

---

This guide ensures consistent, high-quality code generation. When in doubt, follow existing patterns in the codebase and prioritize clarity and maintainability.

# important-instruction-reminders
Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.
NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.