// ABOUTME: Loading view component for displaying loading states
// ABOUTME: Provides consistent loading indicators with optional message

import SwiftUI

public struct LoadingView: View {
    let message: String?

    public init(message: String? = nil) {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: .spacingM) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(.buttonPrimary)

            if let message {
                Text(message)
                    .body(.medium)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.paddingM)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityMessage)
    }

    private var accessibilityMessage: String {
        if let message {
            LocalizedStrings.Accessibility.loadingWithMessage.formatted(with: message)
        } else {
            LocalizedStrings.Common.loading
        }
    }
}

#Preview("Loading View") {
    VStack(spacing: .spacingXL) {
        LoadingView()

        LoadingView(message: "Fetching posts...")

        LoadingView(message: "This might take a moment while we load your content from the server.")
    }
    .padding()
}
