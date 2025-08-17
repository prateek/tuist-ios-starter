// ABOUTME: Consistent spacing system for layout and padding
// ABOUTME: Provides a scale of spacing values that work across different screen sizes

import SwiftUI

public enum Spacing {
    /// 4pt
    case extraSmall
    /// 8pt
    case small
    /// 16pt
    case medium
    /// 24pt
    case large
    /// 32pt
    case extraLarge
    /// 48pt
    case xxl
    
    public var value: CGFloat {
        switch self {
        case .extraSmall: return 4
        case .small: return 8
        case .medium: return 16
        case .large: return 24
        case .extraLarge: return 32
        case .xxl: return 48
        }
    }
}

public extension CGFloat {
    static let spacingXS = Spacing.extraSmall.value
    static let spacingS = Spacing.small.value
    static let spacingM = Spacing.medium.value
    static let spacingL = Spacing.large.value
    static let spacingXL = Spacing.extraLarge.value
    static let spacingXXL = Spacing.xxl.value
}

public extension EdgeInsets {
    static let paddingXS = EdgeInsets(top: .spacingXS, leading: .spacingXS, bottom: .spacingXS, trailing: .spacingXS)
    static let paddingS = EdgeInsets(top: .spacingS, leading: .spacingS, bottom: .spacingS, trailing: .spacingS)
    static let paddingM = EdgeInsets(top: .spacingM, leading: .spacingM, bottom: .spacingM, trailing: .spacingM)
    static let paddingL = EdgeInsets(top: .spacingL, leading: .spacingL, bottom: .spacingL, trailing: .spacingL)
}