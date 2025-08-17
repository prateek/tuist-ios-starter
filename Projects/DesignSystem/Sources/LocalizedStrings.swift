// ABOUTME: Centralized string literals prepared for future localization
// ABOUTME: Provides type-safe access to user-facing strings with localization support

import Foundation

public enum LocalizedStrings {
    // MARK: - Common UI

    public enum Common {
        public static let loading = "Loading"
        public static let error = "Error"
        public static let retry = "Try Again"
        public static let save = "Save"
        public static let cancel = "Cancel"
        public static let reset = "Reset"
        public static let ok = "OK"
    }

    // MARK: - Loading States

    public enum Loading {
        public static let posts = "Loading posts..."
        public static let content = "Loading content..."
        public static let refreshing = "Refreshing..."
        public static let generic = "Loading..."
    }

    // MARK: - Error Messages

    public enum Error {
        public static let somethingWentWrong = "Something went wrong"
        public static let checkConnection = "Please check your internet connection."
        public static let tryAgain = "Try again later."
    }

    // MARK: - Settings

    public enum Settings {
        public static let title = "Settings"
        public static let profile = "Profile"
        public static let preferences = "Preferences"
        public static let username = "Username"
        public static let enterUsername = "Enter username"
        public static let pushNotifications = "Push Notifications"
        public static let theme = "Theme"
        public static let saveSettings = "Save Settings"
        public static let resetToDefaults = "Reset to Defaults"
        public static let settingsSaved = "Settings Saved"
        public static let settingsSavedMessage = "Your settings have been saved successfully."
        public static let resetSettings = "Reset Settings"
        public static let resetConfirmation = "Are you sure you want to reset all settings to their default values?"
    }

    // MARK: - Navigation

    public enum Navigation {
        public static let home = "Home"
        public static let settings = "Settings"
    }

    // MARK: - Accessibility

    public enum Accessibility {
        public static let post = "Post"
        public static let loadingWithMessage = "Loading. %@"
        public static let postContent = "Post: %@. %@"
    }
}

// MARK: - Helper Extensions

public extension String {
    /// Format string with arguments for localization-ready implementation
    func formatted(with arguments: CVarArg...) -> String {
        String(format: self, arguments: arguments)
    }
}
