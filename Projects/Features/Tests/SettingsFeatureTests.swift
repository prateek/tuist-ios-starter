// EXAMPLE_BEGIN: Settings feature tests demonstration
// ABOUTME: Tests for SettingsFeature demonstrating form handling and alert testing
// ABOUTME: Shows how to test user interactions, binding actions, and presentation state
// This is example code showing TCA form testing patterns with user interactions and alerts

import ComposableArchitecture
import DesignSystem
import XCTest
@testable import Features

final class SettingsFeatureTests: XCTestCase {
    func testNotificationsToggle() async {
        let store = await TestStore(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }

        await store.send(.notificationsToggleChanged(false)) {
            $0.notificationsEnabled = false
        }

        await store.send(.notificationsToggleChanged(true)) {
            $0.notificationsEnabled = true
        }
    }

    func testThemeChange() async {
        let store = await TestStore(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }

        await store.send(.themeChanged(.dark)) {
            $0.selectedTheme = .dark
        }

        await store.send(.themeChanged(.light)) {
            $0.selectedTheme = .light
        }
    }

    func testSaveButtonShowsAlert() async {
        let store = await TestStore(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }

        await store.send(.saveButtonTapped) {
            $0.alert = AlertState {
                TextState("Settings Saved")
            } actions: {
                ButtonState {
                    TextState("OK")
                }
            } message: {
                TextState("Your settings have been saved successfully.")
            }
        }
    }

    func testResetConfirmation() async {
        let store = await TestStore(
            initialState: SettingsFeature.State(
                notificationsEnabled: false,
                selectedTheme: .dark,
                username: "testuser"
            )
        ) {
            SettingsFeature()
        }

        await store.send(.resetButtonTapped) {
            $0.alert = AlertState {
                TextState("Reset Settings")
            } actions: {
                ButtonState(action: .confirmReset) {
                    TextState("Reset")
                }
                ButtonState(role: .cancel) {
                    TextState("Cancel")
                }
            } message: {
                TextState("Are you sure you want to reset all settings to their default values?")
            }
        }

        await store.send(.alert(.presented(.confirmReset))) {
            $0.notificationsEnabled = true
            $0.selectedTheme = .system
            $0.username = ""
            $0.alert = nil
        }
    }

    func testUsernameBinding() async {
        let store = await TestStore(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }

        await store.send(.binding(.set(\.username, "newuser"))) {
            $0.username = "newuser"
        }
    }
}

// EXAMPLE_END
