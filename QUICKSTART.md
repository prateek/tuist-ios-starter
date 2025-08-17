# 🚀 Quick Start Guide

## Immediate Success (2 minutes)

If you want to see the app working immediately without any network issues:

### Option 1: Local Demo Data
```bash
git clone https://github.com/prateek/tuist-ios-starter.git
cd tuist-ios-starter
tuist install && tuist generate

# Enable local demo mode in NetworkClient.swift temporarily:
# Comment out the #endif line after loadLocalPosts() call
```

Then build and run - you'll see beautiful demo posts that explain the app features!

### Option 2: Use Make Commands
```bash
make setup           # Install and generate project
make debug-local     # Build with local data mode
```

## Full Network Setup (5 minutes)

For production development with real API calls:

1. **Diagnose network issues:**
   ```bash
   make diagnose-network
   ```

2. **If seeing network errors:**
   ```bash
   make clean-simulators    # Reset simulator network (fixes 80% of issues)
   make reset-network       # Clear macOS network cache
   ```

3. **Alternative endpoints:**
   ```bash
   # Use local mock server
   API_BASE_URL=http://localhost:3000 make build
   
   # Use debug data
   DEBUG_LOCAL_DATA=1 make build
   ```

## What You'll See

### 🏠 Home Tab
- **Success**: Beautiful list of posts with titles and content
- **Loading**: Spinner with "Loading posts..." message  
- **Error**: Clear error message with "Try Again" button

### ⚙️ Settings Tab
- **Profile**: Username text field
- **Preferences**: Notifications toggle, Theme picker
- **Actions**: Save Settings, Reset to Defaults buttons

### 🎯 Demo Features
- Smooth tab navigation
- TCA state management
- Error handling and retry logic
- Accessibility support
- Modern SwiftUI design

## Troubleshooting

**Network issues?** → `make clean-simulators`
**Want offline mode?** → `make debug-local`  
**Need custom API?** → Set `API_BASE_URL` environment variable
**App works first time but fails after relaunch?** → This is a known iOS Simulator bug. The fix: `xcrun simctl shutdown all && xcrun simctl erase all`
**Full guide** → See `Documentation/NetworkTroubleshooting.md`

---

💡 **Pro Tip**: The local demo data includes posts that explain the app's architecture and features - perfect for understanding the codebase!