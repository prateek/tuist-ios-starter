// ABOUTME: Testing utilities for DesignSystem components following TMA patterns
// ABOUTME: Provides test helpers, mock data, and SwiftUI testing utilities

import DesignSystem
import SwiftUI

public struct MockDesignSystemData {
    public static let buttonTitles = [
        "Primary Action",
        "Secondary Action", 
        "Destructive Action",
        "Very Long Button Title That Tests Wrapping",
        "🚀 With Emoji"
    ]
    
    public static let loadingMessages = [
        "Loading...",
        "Please wait while we fetch your data",
        "This might take a moment",
        "Almost there..."
    ]
}

public extension PrimaryButton {
    static func mockFilled(title: String = "Test Button") -> PrimaryButton {
        PrimaryButton(title, style: .filled) { }
    }
    
    static func mockOutlined(title: String = "Test Button") -> PrimaryButton {
        PrimaryButton(title, style: .outlined) { }
    }
    
    static func mockText(title: String = "Test Button") -> PrimaryButton {
        PrimaryButton(title, style: .text) { }
    }
    
    static func mockDisabled(title: String = "Disabled Button") -> PrimaryButton {
        PrimaryButton(title, isEnabled: false) { }
    }
}

public extension LoadingView {
    static func mockDefault() -> LoadingView {
        LoadingView(message: "Loading...")
    }
    
    static func mockCustomMessage() -> LoadingView {
        LoadingView(message: "Fetching your amazing content...")
    }
}

// MARK: - Preview Helpers

public struct PreviewContainer<Content: View>: View {
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding()
            .background(Color.backgroundPrimary)
            .preferredColorScheme(.light)
    }
}