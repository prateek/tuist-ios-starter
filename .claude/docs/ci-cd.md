# CI/CD & GitHub Actions

## 🚀 GitHub Actions Workflows

### **Workflow Structure**
The project includes modern CI/CD workflows in `.github/workflows/`:

- **Code Quality Job**: SwiftFormat (formatting) + SwiftLint (quality) validation with tool separation
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

### **Environment Variables**
```yaml
env:
  HOMEBREW_NO_AUTO_UPDATE: 1          # Skip brew updates (saves 2-3 minutes)
  CI: 1                               # Enable non-interactive mode
  TUIST_CONFIG_TOKEN: ${{ secrets.TUIST_CONFIG_TOKEN }}  # Enable cloud features
```

### **⚡ Tuist Cloud Integration**
The CI is configured to use Tuist cloud features for optimal performance:

- **Binary Caching**: 65-90% build time reduction through cached dependencies
- **Selective Testing**: Only runs tests affected by code changes
- **Bundle Analysis**: Tracks app bundle size over time
- **Project Analytics**: Insights into build performance and patterns

**Setup for new projects**:
```bash
tuist auth login
tuist project create your-handle/your-project-name
tuist project tokens create your-handle/your-project-name > /tmp/token.txt
gh secret set TUIST_CONFIG_TOKEN < /tmp/token.txt
rm /tmp/token.txt
```

## 🎭 Local CI Testing with Act

### **Act Self-Hosted Mode**: Run complete CI pipeline locally using native macOS tools:

```bash
# Complete CI simulation (all jobs)
make validate-ci-act      # Run full CI pipeline with act

# Individual job testing  
make validate-ci-jobs     # Test Code Quality + Build & Test jobs separately

# Workflow structure validation
make validate-ci-dry      # Validate YAML structure and job logic
```

### **How it works**:
- Uses `act -P macos-15=-self-hosted` to run on native macOS (not Docker)
- Accesses your local Xcode, simulators, and Homebrew tools
- Runs the exact same commands as GitHub Actions CI
- Provides identical feedback to what CI will produce

### **Configuration**: 
`.actrc` file automatically configures act for iOS development:
```bash
-P macos-15=-self-hosted      # Use native macOS execution
--pull=false                  # Don't pull Docker images
--action-offline-mode         # Use local action cache
```

## 🔄 Pre-Commit Hooks

### **Hook Sequence**
Every commit is automatically validated through pre-commit hooks that ensure:
- ✅ **Code Formatting**: SwiftFormat handles ALL formatting (braces, commas, spacing)
- ✅ **Code Quality**: SwiftLint enforces coding standards and TCA patterns (no formatting)
- ✅ **Build Success**: Project compiles without errors
- ✅ **Test Passing**: All tests pass before commit
- ✅ **File Safety**: ASCII filenames, no focused tests (fdescribe/fit)

**Tool Separation**: SwiftFormat and SwiftLint have distinct, non-overlapping responsibilities to eliminate formatting conflicts.

### **Setup** (one-time per developer):
```bash
make setup-hooks              # Install pre-commit hooks
```

### **Daily Usage** (automatic):
- Hooks run on every `git commit`
- Failed hooks block commits with clear error messages
- Most issues auto-fixed (formatting) or provide fix instructions

### **Troubleshooting**:
```bash
pre-commit run --all-files    # Test all hooks manually
git commit --no-verify       # Emergency bypass (use sparingly)
pre-commit uninstall         # Remove hooks if needed
```

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

## 📊 Performance Monitoring

### **Build Performance**
- **Tuist Caching**: Significant build time improvements
- **Act Local Testing**: Faster feedback than pushing to CI
- **Tool Separation**: Eliminates redundant formatting cycles

### **CI Optimization**
- **No brew updates**: Saves 2-3 minutes per run
- **Tuist caching**: Faster dependency resolution
- **Proper tool sequence**: SwiftFormat → SwiftLint (no conflicts)