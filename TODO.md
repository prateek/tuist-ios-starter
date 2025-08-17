# TODO

## Code Signing & Device Installation

- [ ] **Add proper code signing configuration for device builds**
  - Replace `"YOUR_TEAM_ID_HERE"` placeholder in Project.swift with environment variable approach
  - Configure automatic code signing with development team ID
  - Enable `tuist share --platforms ios` for device installation support
  - Test device installation workflow end-to-end

## Testing & Validation

- [ ] **Validate `tuist share` workflow**
  - Test simulator builds with `tuist share` (currently working)
  - Test device builds after code signing is configured
  - Verify preview links work for both simulator and device installation
  - Document troubleshooting steps for common signing issues