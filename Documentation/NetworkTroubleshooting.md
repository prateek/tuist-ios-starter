# Network Troubleshooting Guide

This guide helps resolve common network connectivity issues in the iOS Simulator when developing with the Claude Code starter template.

## 🚨 Quick Fixes

If the app shows "Network error" messages, try these solutions in order:

### ⚡ First Launch Works, Relaunch Fails (Common Simulator Bug)
**Symptom**: App works on first launch but network fails after closing and reopening  
**Cause**: iOS Simulator network daemon cache corruption  
**Fix**: `xcrun simctl shutdown all && xcrun simctl erase all` (resets network state)  
**Prevention**: The app now includes simulator-specific code to avoid this issue

### 1. Simulator Network Reset (Most Common Fix)
```bash
make clean-simulators  # Resets all simulators
make reset-network     # Clears macOS network cache
```

### 2. Use Local Data Mode
```bash
make debug-local      # Runs app with bundled data (no network)
```

### 3. Check Host Connectivity
```bash
make diagnose-network # Tests if external API is reachable
```

## 🔍 Detailed Diagnosis

### Check Host Network First
```bash
curl -v https://jsonplaceholder.typicode.com/posts
```

**Expected**: Should return JSON data with 200 status  
**If fails**: Check your internet connection, VPN, or corporate proxy

### iOS Simulator Network Issues

#### Common Causes:
1. **Simulator network cache corruption** - Fixed by `xcrun simctl erase all`
2. **Corporate proxy/VPN interference** - Simulator may not inherit host proxy settings
3. **Certificate trust issues** - Custom corporate certificates may not be trusted in simulator
4. **DNS resolution problems** - Simulator may use different DNS than host

#### Simulator-Specific Fixes:

**Reset Simulator Network:**
```bash
xcrun simctl erase all                    # Nuclear reset (erases all data)
xcrun simctl shutdown all                 # Gentler shutdown first
```

**Import Corporate Certificates (if needed):**
1. Open simulator
2. Drag your company's `.cer` certificate file into the simulator
3. Install via Settings → General → Profiles & Device Management

**Check Simulator Network Settings:**
```bash
xcrun simctl diagnose  # Creates diagnostic bundle with network logs
```

## 🏢 Corporate Environment Setup

### Proxy Configuration
If your company uses a proxy, you may need to:

1. **Check proxy settings:** System Preferences → Network → Advanced → Proxies
2. **Bypass proxy for local development:**
   ```bash
   export NO_PROXY=localhost,127.0.0.1,*.local
   ```
3. **Use local mock server:**
   ```bash
   export API_BASE_URL=http://localhost:3000
   # Then run a local json-server
   ```

### VPN Issues
- **Disable VPN temporarily** to test if it's blocking simulator network
- **Split tunneling:** Configure VPN to exclude simulator traffic
- **Use local data mode** for offline development: `make debug-local`

## 🧪 Testing Network Conditions

The app includes several testing modes:

### Local Data Mode
```bash
DEBUG_LOCAL_DATA=1 # Uses bundled posts.json
```

### Custom API Endpoint
```bash
API_BASE_URL=http://localhost:3000 # Points to local mock server
```

### Network Condition Simulation
Use Xcode's Network Link Conditioner:
1. Xcode → Open Developer Tool → Network Link Conditioner
2. Choose condition: 3G, Edge, High Latency DNS, etc.
3. Test app behavior under poor network conditions

## 📱 Simulator-Specific Commands

### List Available Simulators
```bash
xcrun simctl list devices
```

### Boot Specific Simulator
```bash
xcrun simctl boot "iPhone 16"
```

### Install App in Simulator
```bash
xcrun simctl install "iPhone 16" /path/to/App.app
```

### Launch App with Custom Environment
```bash
xcrun simctl launch "iPhone 16" com.claudecode.starter.app DEBUG_LOCAL_DATA 1
```

## ⚡ Performance Optimization

### Timeout Configuration
The app uses optimized timeouts for simulator development:
- **Request timeout**: 15 seconds (vs. default 60s)
- **Resource timeout**: 30 seconds
- **Retry attempts**: 2 with exponential backoff

### Network Monitoring
The app monitors network connectivity and adjusts behavior:
- **Online**: Attempts network requests with retry logic
- **Offline**: Shows appropriate offline messaging
- **Poor connection**: Shorter timeouts prevent long waits

## 🆘 When All Else Fails

1. **Restart Xcode** - Clears any lingering network configuration
2. **Restart Mac** - Nuclear option for persistent network issues
3. **Use local data mode** - Guaranteed to work offline: `make debug-local`
4. **Check system logs** - `Console.app` → filter by "iOS Simulator"

## 📋 Troubleshooting Checklist

- [ ] Curl command works from Terminal (`make diagnose-network`)
- [ ] Simulator is reset (`make clean-simulators`)
- [ ] Network cache is cleared (`make reset-network`)
- [ ] No corporate proxy/VPN blocking requests
- [ ] Certificates are trusted in simulator (if corporate environment)
- [ ] Xcode is running latest version
- [ ] Local data mode works (`make debug-local`)

## 🔗 Additional Resources

- [Apple Developer - Simulator User Guide](https://developer.apple.com/documentation/xcode/simulator-user-guide)
- [Network Link Conditioner](https://developer.apple.com/documentation/xcode/network-link-conditioner)
- [iOS Simulator Network Configuration](https://developer.apple.com/forums/tags/ios-simulator)

---

💡 **Pro Tip**: For reliable demos, always test with `make debug-local` first to ensure the app UI works correctly, then test network functionality separately.