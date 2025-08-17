// ABOUTME: Design system colors following Apple's semantic color approach
// ABOUTME: Provides consistent color tokens that adapt to light/dark mode automatically

import SwiftUI

public extension Color {
    // MARK: - Primary Colors
    static let primaryBlue = Color("PrimaryBlue", bundle: .module)
    static let primaryGreen = Color("PrimaryGreen", bundle: .module)
    static let primaryRed = Color("PrimaryRed", bundle: .module)
    
    // MARK: - Semantic Colors
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let backgroundPrimary = Color(.systemBackground)
    static let backgroundSecondary = Color(.secondarySystemBackground)
    static let backgroundTertiary = Color(.tertiarySystemBackground)
    
    // MARK: - Interactive Colors
    static let buttonPrimary = Color.accentColor
    static let buttonSecondary = Color(.systemGray4)
    static let destructive = Color(.systemRed)
}

public extension Color {
    // Helper for when we need UIColor
    var uiColor: UIColor {
        UIColor(self)
    }
}