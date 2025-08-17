// ABOUTME: Testing utilities for Features module following TMA patterns
// ABOUTME: Provides test stores, mock states, and testing helpers for TCA features

import ComposableArchitecture
import CoreKit
import CoreKitTesting
import Features
import Foundation

public extension HomeFeature {
    static func testStore(
        initialState: State = State(),
        networkClient: NetworkClient = NetworkClient.testValue
    )
        -> TestStore<State, Action>
    {
        TestStore(initialState: initialState) {
            HomeFeature()
        } withDependencies: {
            $0.networkClient = networkClient
        }
    }
}

public extension SettingsFeature {
    static func testStore(
        initialState: State = State()
    )
        -> TestStore<State, Action>
    {
        TestStore(initialState: initialState) {
            SettingsFeature()
        }
    }
}

public extension RootFeature {
    static func testStore(
        initialState: State = State()
    )
        -> TestStore<State, Action>
    {
        TestStore(initialState: initialState) {
            RootFeature()
        }
    }
}

public enum MockStates {
    public static let homeLoading = HomeFeature.State(isLoading: true)
    public static let homeWithPosts = HomeFeature.State(posts: TestData.samplePosts)
    public static let homeWithError = HomeFeature.State(error: "Network error occurred")

    public static let settingsDefault = SettingsFeature.State()

    public static func rootWithTab(_ tab: RootFeature.Tab) -> RootFeature.State {
        var state = RootFeature.State()
        state.selectedTab = tab
        return state
    }

    public static let rootHomeSelected = rootWithTab(.home)
    public static let rootSettingsSelected = rootWithTab(.settings)
}
