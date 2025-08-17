# Code Quality & Tool Integration

## 🛠️ SwiftFormat/SwiftLint Tool Separation Strategy

### **Industry-Standard Tool Hierarchy**

Based on research from Google, Airbnb, and community best practices, we implement clear tool separation to eliminate conflicts:

**SwiftFormat Authority**: ALL formatting concerns
- Braces, commas, spacing, indentation, layout
- Handles multi-line array formatting per community standards
- Single source of truth for code appearance

**SwiftLint Authority**: ONLY code quality concerns  
- Complexity, naming, architecture patterns
- TCA-specific rules, best practices
- No formatting overlap with SwiftFormat

### **Configuration Implementation**

**SwiftLint Config** (`.swiftlint.yml`):
```yaml
# Disabled rules - Let SwiftFormat handle ALL formatting
disabled_rules:
  - todo
  - line_length        # SwiftFormat authority
  - opening_brace      # SwiftFormat authority  
  - trailing_comma     # SwiftFormat authority
  - indentation_width  # SwiftFormat authority
  - vertical_whitespace # SwiftFormat authority
```

**SwiftFormat Config** (`.swiftformat`):
```bash
# Community-aligned formatting rules
--allman false                              # K&R style (braces on same line)
--disable wrapMultilineStatementBraces     # Prevents SwiftLint conflicts
--wrapcollections before-first             # Consistent collection formatting
--trimwhitespace always                    # Clean whitespace
```

### **Development Workflow**

**Recommended Command Sequence:**
```bash
# Combined workflow (recommended)
make format-lint            # Format first, then quality check

# Individual commands
make format                 # SwiftFormat: ALL formatting
make lint                   # SwiftLint: ONLY code quality
```

**Tool Responsibilities:**
- **SwiftFormat**: Braces, commas, spacing, indentation, layout
- **SwiftLint**: Complexity, naming, TCA patterns, architecture rules
- **No Overlap**: Eliminates infinite formatting cycles

### **Pre-Commit Hooks Integration**

The pre-commit hooks follow the tool hierarchy:

```yaml
# .pre-commit-config.yaml sequence
- id: swiftformat    # Format files first
- id: swiftlint      # Quality check only (no auto-fix)
```

**Benefits:**
- ✅ Eliminates infinite formatting cycles
- ✅ Clear tool responsibilities  
- ✅ Industry-standard approach
- ✅ Zero conflicts between tools
- ✅ Consistent with community practices

### **CI Integration**

GitHub Actions workflow follows proper tool sequence:

```yaml
- name: SwiftFormat Check (formatting authority)
  run: swiftformat --lint .
  
- name: SwiftLint Check (code quality only)
  run: swiftlint --strict
```

**Key Points:**
- SwiftFormat runs first (formatting authority)
- SwiftLint runs second (quality only, no formatting rules)
- Both tools must pass for CI success
- No tool conflicts or infinite cycles

## 🎯 Custom SwiftLint Rules

### **TCA-Specific Rules**
```yaml
custom_rules:
  reducer_naming:
    name: "Reducer Naming"
    regex: '(struct|class)\s+(?!.*(?:Reducer|Feature))\w+\s*:\s*.*Reducer'
    message: "Reducers should be named with 'Feature' or 'Reducer' suffix"
    severity: warning

  action_naming:
    name: "Action Case Naming"
    regex: 'case\s+[A-Z]'
    message: "Action cases should start with lowercase"
    severity: warning
```

### **TMA Module Boundary Rules**
```yaml
  no_ui_in_corekit:
    name: "No UI Imports in CoreKit"
    regex: "^import (SwiftUI|UIKit)"
    included: "Projects/CoreKit/Sources/.*\\.swift"
    message: "CoreKit should not import UI frameworks. Move UI code to Features or DesignSystem."
    severity: error

  no_features_in_corekit:
    name: "No Features Import in CoreKit"
    regex: "^import Features"
    included: "Projects/CoreKit/Sources/.*\\.swift"
    message: "CoreKit should not import Features. Features depend on CoreKit, not vice versa."
    severity: error
```

### **Testing Safety Rules**
```yaml
  no_generic_test_types:
    name: "No Generic Test Type Names"
    regex: "\\b(TestData|Helpers|Utils)\\."
    included: ".*Tests/.*\\.swift"
    message: "Use domain-specific names (RecordingTestData, AudioHelpers) to prevent namespace conflicts"
    severity: error
```

## 🚀 Best Practices

1. **Format First**: Always run SwiftFormat before SwiftLint
2. **No Manual Fixes**: Never use `swiftlint --fix` (formatting is SwiftFormat's job)
3. **Quality Focus**: Use SwiftLint for architecture, complexity, and naming
4. **Community Standards**: Follow Google/Airbnb conventions via SwiftFormat
5. **Zero Conflicts**: Maintain distinct tool responsibilities