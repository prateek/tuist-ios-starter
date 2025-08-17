## 🔧 Tool Selection Guidelines

### **MCP Tools vs CLI Tools - When to Use What**

**✅ PREFER: MCP XcodeBuildMCP Tools (When Available)**

Use MCP tools as your **first choice** for Xcode and simulator interactions:

```bash
# ✅ PREFERRED: MCP tools provide higher-level abstractions
mcp__XcodeBuildMCP__build_run_ios_sim_name_ws  # vs xcodebuild + xcrun simctl launch
mcp__XcodeBuildMCP__screenshot                 # vs xcrun simctl io screenshot
mcp__XcodeBuildMCP__tap                       # vs manual simulator interaction
mcp__XcodeBuildMCP__launch_app_logs_sim       # vs xcrun simctl spawn log
```

**Why MCP Tools Are Better:**
- **Higher-level abstractions** - handle complex parameter construction automatically
- **Better error handling** - built-in retry logic and clearer error messages
- **State management** - track simulator state and handle edge cases
- **Consistency** - standardized interface across Xcode/simulator versions
- **UI testing capabilities** - seamless `tap`, `swipe`, `type_text` interactions
- **Claude integration** - designed to work optimally with AI workflows

**🔄 FALLBACK: CLI Tools (When MCP Not Available)**

Use CLI tools when MCP doesn't cover your specific need:

```bash
# ✅ ACCEPTABLE: CLI fallbacks for specific cases
xcrun simctl list devices                      # Device enumeration
xcodebuild -showBuildSettings                 # Detailed build configuration
xcrun simctl get_app_container DEVICE BUNDLE  # App container inspection
plutil -p Info.plist                          # Plist file inspection
```

**When CLI Tools Are Appropriate:**
- Quick debugging and inspection commands
- Specific xcodebuild parameters not exposed by MCP
- Educational purposes (learning underlying commands)
- One-off administrative tasks

### **Practical Examples**

**✅ MCP Approach (Recommended):**
```bash
# Complete UI testing workflow with MCP
mcp__XcodeBuildMCP__build_run_ios_sim_name_ws
mcp__XcodeBuildMCP__screenshot
mcp__XcodeBuildMCP__tap "Record Button"
mcp__XcodeBuildMCP__type_text "Test input"
mcp__XcodeBuildMCP__launch_app_logs_sim
```

**🔄 CLI Approach (Fallback):**
```bash
# Manual CLI workflow - more complex and error-prone
tuist run App
xcrun simctl io D4724415-45BD-43FE-A1CC-2C5573C82EFE screenshot test.png
# Manual simulator interaction required
xcrun simctl spawn D4724415-45BD-43FE-A1CC-2C5573C82EFE log show --last 30s
```

**Decision Tree:**
1. **Does MCP XcodeBuildMCP have the functionality?** → Use MCP tool
2. **Need specific CLI-only feature?** → Use CLI tool
3. **Debugging or learning?** → CLI tool acceptable
4. **Production workflow?** → Prefer MCP tools for reliability


 # Critical Swift Testing Infrastructure Guidelines

  ## MANDATORY: Prevent Namespace Conflicts & Test Hangs

  You are working on a Swift/iOS project. Follow these CRITICAL patterns to prevent mysterious test failures and infinite hangs that waste hours of debugging time.

  ### 🚨 NAMESPACE SAFETY RULES

  **NEVER use generic type names across multiple test modules:**

  ❌ **DANGEROUS PATTERN (causes infinite test hangs):**
  ```swift
  // Module A: SharedTestSupport
  public enum TestData { static let posts = [...] }

  // Module B: CoreKitTesting
  public struct TestData { static let recordings = [...] }

  // Test file importing both - THIS WILL HANG TESTS!
  import SharedTestSupport
  import CoreKitTesting
  let data = TestData.recordings // Swift resolves incorrectly at runtime

  ✅ SAFE PATTERN:
  // Use domain-specific names
  public enum PostTestData { static let posts = [...] }
  public struct RecordingTestData { static let recordings = [...] }

  // Clear and unambiguous
  let data = RecordingTestData.recordings

  🛡️ FAIL-FAST TEST PATTERNS

  MANDATORY for all test fixtures:

  1. Add precondition guards to all test factories:
  public static func createSample(id: Int, title: String) -> Model {
      precondition(id > 0, "❌ TEST FIXTURE ERROR: ID must be positive, got \(id)")
      precondition(!title.isEmpty, "❌ TEST FIXTURE ERROR: Title cannot be empty")
      return Model(id: id, title: title)
  }

  2. Use XCTUnwrap instead of force unwraps:
  // ❌ WRONG: Silent crash
  let item = array.first!

  // ✅ CORRECT: Clear test failure
  let item = try XCTUnwrap(array.first, "Expected at least one item")

  3. Add timeouts to ALL async test assertions:
  // TCA/TestStore specific:
  await store.receive(.action, timeout: .milliseconds(500)) { /* state */ }
  await store.finish(timeout: .seconds(2))

  // General async tests:
  let result = try await withTimeout(.seconds(1)) {
      await someOperation()
  }

  🔧 TCA-SPECIFIC RULES

  For Composable Architecture projects:

  1. Always call store.finish() in async tests:
  func testAsyncAction() async {
      let store = TestStore(...)
      await store.send(.action)
      await store.receive(.response)
      await store.finish() // ✅ PREVENTS HANGS
  }

  2. Mock ALL dependencies used in tested effects:
  // ❌ WRONG: Missing dependencies cause hangs
  let store = Feature.testStore(audioService: .testValue)

  // ✅ CORRECT: Mock everything the effect touches
  let store = Feature.testStore(
      audioService: .testValue,
      recordingStore: .testValue,
      networkClient: .testValue
  )

  📋 PRE-COMMIT CHECKLIST

  Before committing any test code, verify:
  - No generic type names (TestData, Helpers, Utils) across modules
  - All test fixtures use precondition() validation
  - All async tests have explicit timeouts
  - All store.receive() calls have timeout parameters
  - All test dependencies are mocked (no live dependencies in tests)
  - Force unwraps replaced with XCTUnwrap

  🚨 RED FLAGS - WILL CAUSE ISSUES

  Immediately fix if you see:
  - Multiple modules with same helper type names
  - store.receive() without timeout parameters
  - Missing store.finish() in async TCA tests
  - Force unwraps (!) in test fixture construction
  - Mixed live and test dependencies
  - Generic factory names across test modules

  💡 WHY THIS MATTERS

  The Problem: Swift's type resolution can compile successfully but resolve to wrong types at runtime, causing:
  - Tests that hang infinitely instead of failing clearly
  - Silent crashes in async effects that appear as hangs
  - Hours of debugging mysterious test infrastructure issues

  The Solution: Fail-fast patterns make issues obvious immediately:
  - Namespace conflicts become compile-time errors
  - Invalid data causes immediate precondition failures
  - Timeouts convert hangs into clear test failures
  - Validation provides specific error messages for quick fixes

  🛠️ IMPLEMENTATION

  Apply these patterns to:
  - All test helper modules
  - All TestStore usage
  - All mock service implementations
  - All async test methods
  - All fixture factory methods

  Add SwiftLint custom rule:
  custom_rules:
    no_generic_test_types:
      name: "No Generic Test Type Names"
      regex: "\\b(TestData|Helpers|Utils)\\."
      included: ".*Tests/.*\\.swift"
      message: "Use domain-specific names (RecordingTestData, AudioHelpers) to prevent namespace conflicts"
      severity: error

  Following these patterns religiously will prevent the majority of mysterious test infrastructure failures and make debugging infinitely easier when issues do occur.
