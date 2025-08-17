// ABOUTME: Consistent corner radius system for UI components
// ABOUTME: Provides a scale of corner radius values that work across different component sizes

import SwiftUI

public enum CornerRadius {
    /// 4pt - Small elements like badges
    case small
    /// 8pt - Standard buttons and cards
    case medium
    /// 12pt - Larger components
    case large
    /// 16pt - Modal sheets and major containers
    case extraLarge
    /// 24pt - Hero elements and special containers
    case xxl

    public var value: CGFloat {
        switch self {
        case .small: 4
        case .medium: 8
        case .large: 12
        case .extraLarge: 16
        case .xxl: 24
        }
    }
}

public extension CGFloat {
    /// Design token namespace for corner radius values
    enum CornerRadius {
        public static let small: CGFloat = 4
        public static let medium: CGFloat = 8
        public static let large: CGFloat = 12
        public static let extraLarge: CGFloat = 16
        public static let xxl: CGFloat = 24
    }
}

public extension View {
    /// Apply corner radius using design token
    func cornerRadius(_ radius: CornerRadius) -> some View {
        self.cornerRadius(radius.value)
    }
}
