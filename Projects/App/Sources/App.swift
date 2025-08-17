// ABOUTME: Main application entry point using SwiftUI and TCA
// ABOUTME: Sets up the root store and provides the main app structure

import ComposableArchitecture
import Features
import SwiftUI

@main
struct ClaudeCodeStarterApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                store: Store(initialState: RootFeature.State()) {
                    RootFeature()
                }
            )
        }
    }
}
