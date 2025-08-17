// ABOUTME: Primary button component following Apple HIG guidelines
// ABOUTME: Provides consistent button styling with accessibility support

import SwiftUI

public struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let isEnabled: Bool
    let style: Style

    public init(
        _ title: String,
        style: Style = .filled,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(title)
                    .font(.buttonText)
                    .foregroundColor(textColor)
                Spacer()
            }
            .padding(.vertical, .spacingS)
            .padding(.horizontal, .spacingM)
            .background(backgroundColor)
            .cornerRadius(.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CGFloat.CornerRadius.medium)
                    .stroke(borderColor, lineWidth: style == .outlined ? 1 : 0)
            )
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(title)
    }

    private var backgroundColor: Color {
        switch style {
        case .filled:
            .buttonPrimary
        case .outlined, .text:
            .clear
        }
    }

    private var textColor: Color {
        switch style {
        case .filled:
            .white
        case .outlined, .text:
            .buttonPrimary
        }
    }

    private var borderColor: Color {
        switch style {
        case .filled, .text:
            .clear
        case .outlined:
            .buttonPrimary
        }
    }
}

public extension PrimaryButton {
    enum Style {
        case filled
        case outlined
        case text
    }
}

#Preview("Primary Button Styles") {
    VStack(spacing: .spacingM) {
        PrimaryButton("Filled Button", style: .filled) {
            print("Filled button tapped")
        }

        PrimaryButton("Outlined Button", style: .outlined) {
            print("Outlined button tapped")
        }

        PrimaryButton("Text Button", style: .text) {
            print("Text button tapped")
        }

        PrimaryButton("Disabled Button", isEnabled: false) {
            print("This won't be called")
        }
    }
    .padding()
}
