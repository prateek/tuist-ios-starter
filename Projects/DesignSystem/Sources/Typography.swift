// ABOUTME: Typography system using Apple's Dynamic Type for accessibility
// ABOUTME: Provides consistent text styles that scale with user preferences

import SwiftUI

public extension Font {
    // MARK: - Headings
    static let headingLarge = Font.largeTitle.weight(.bold)
    static let headingMedium = Font.title.weight(.semibold)
    static let headingSmall = Font.title2.weight(.semibold)
    
    // MARK: - Body Text
    static let bodyLarge = Font.body
    static let bodyMedium = Font.callout
    static let bodySmall = Font.caption
    
    // MARK: - UI Elements
    static let buttonText = Font.headline.weight(.medium)
    static let captionText = Font.caption2
    static let labelText = Font.subheadline.weight(.medium)
}

public struct Typography {
    // MARK: - Text Modifiers
    public static func heading(_ level: HeadingLevel) -> some ViewModifier {
        return HeadingModifier(level: level)
    }
    
    public static func body(_ style: BodyStyle) -> some ViewModifier {
        return BodyModifier(style: style)
    }
}

public enum HeadingLevel {
    case large, medium, small
    
    var font: Font {
        switch self {
        case .large: return .headingLarge
        case .medium: return .headingMedium
        case .small: return .headingSmall
        }
    }
}

public enum BodyStyle {
    case large, medium, small
    
    var font: Font {
        switch self {
        case .large: return .bodyLarge
        case .medium: return .bodyMedium
        case .small: return .bodySmall
        }
    }
}

// MARK: - View Modifiers
private struct TextStyleModifier: ViewModifier {
    let font: Font
    let color: Color
    
    init(font: Font, color: Color = .textPrimary) {
        self.font = font
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }
}

private struct HeadingModifier: ViewModifier {
    let level: HeadingLevel
    
    func body(content: Content) -> some View {
        content
            .modifier(TextStyleModifier(font: level.font))
    }
}

private struct BodyModifier: ViewModifier {
    let style: BodyStyle
    
    func body(content: Content) -> some View {
        content
            .modifier(TextStyleModifier(font: style.font))
    }
}

// MARK: - View Extensions
public extension View {
    func heading(_ level: HeadingLevel) -> some View {
        modifier(HeadingModifier(level: level))
    }
    
    func body(_ style: BodyStyle) -> some View {
        modifier(BodyModifier(style: style))
    }
}