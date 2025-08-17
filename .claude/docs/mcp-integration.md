# MCP Integration & AI Tools

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

## 🌐 MCP Servers & AI Integration

### **Available MCP Servers**
The project includes pre-configured MCP (Model Context Protocol) servers for enhanced AI capabilities:

**🧠 Zen MCP**: Advanced thinking, debugging, and analysis tools
- **Purpose**: Multi-model consensus, deep analysis, code review workflows
- **Tools**: thinkdeep, consensus, debug, analyze, refactor, precommit
- **Configuration**: Auto-configured in `.mcp.json`

**🐙 GitHub MCP**: Direct GitHub integration and repository management
- **Purpose**: Issues, PRs, repositories, project management from Claude Code
- **Tools**: Repository access, issue management, pull request operations
- **Setup**: Requires GitHub authentication via `gh` CLI

### **GitHub MCP Setup**
```bash
# One-time setup
gh auth login                                    # Authenticate with GitHub
gh auth refresh --scopes "repo,read:packages,read:org" --hostname github.com
echo "GITHUB_PAT=$(gh auth token)" > .env        # Create secure .env file

# Or use the automated setup
make setup                                       # Includes GitHub MCP setup
```

**Configuration**: 
- **Secure**: Uses `.env` file (gitignored) with dynamic `gh auth token`
- **Team-friendly**: Each developer uses their own GitHub credentials  
- **No hardcoded secrets**: Safe to commit `.mcp.json` configuration
- **Auto-renewal**: gh CLI handles token refresh

### **MCP Server Benefits**
- **Enhanced capabilities**: Access to specialized AI tools beyond base Claude
- **GitHub integration**: Direct repository and project management
- **Secure authentication**: Environment variable based, no committed secrets
- **Team consistency**: Shared `.mcp.json` ensures everyone has same tools