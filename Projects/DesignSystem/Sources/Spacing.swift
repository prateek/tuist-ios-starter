// ABOUTME: Consistent spacing system for layout and padding
// ABOUTME: Provides a scale of spacing values that work across different screen sizes

import SwiftUI

public enum Spacing {
    /// 2pt - Minimal spacing
    case xxs
    /// 4pt - Very tight spacing
    case extraSmall
    /// 6pt - Intermediate tight spacing
    case smallMedium
    /// 8pt - Standard small spacing
    case small
    /// 12pt - Intermediate medium spacing
    case mediumSmall
    /// 16pt - Standard medium spacing
    case medium
    /// 20pt - Intermediate large spacing
    case mediumLarge
    /// 24pt - Standard large spacing
    case large
    /// 32pt - Extra large spacing
    case extraLarge
    /// 48pt - Maximum spacing
    case xxl

    public var value: CGFloat {
        switch self {
        case .xxs: 2
        case .extraSmall: 4
        case .smallMedium: 6
        case .small: 8
        case .mediumSmall: 12
        case .medium: 16
        case .mediumLarge: 20
        case .large: 24
        case .extraLarge: 32
        case .xxl: 48
        }
    }
}

public extension CGFloat {
    static let spacingXXS = Spacing.xxs.value
    static let spacingXS = Spacing.extraSmall.value
    static let spacingSM = Spacing.smallMedium.value
    static let spacingS = Spacing.small.value
    static let spacingMS = Spacing.mediumSmall.value
    static let spacingM = Spacing.medium.value
    static let spacingML = Spacing.mediumLarge.value
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
