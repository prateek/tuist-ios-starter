// ABOUTME: Root feature that manages the main app navigation and coordination
// ABOUTME: Uses TabView to coordinate between Home and Settings features

import ComposableArchitecture
import SwiftUI

@Reducer
public struct RootFeature {
    @ObservableState
    public struct State: Equatable {
        public var selectedTab: Tab = .home
        public var homeFeature = HomeFeature.State()
        public var settingsFeature = SettingsFeature.State()

        public init() {}
    }

    public enum Action: Equatable {
        case tabSelected(Tab)
        case home(HomeFeature.Action)
        case settings(SettingsFeature.Action)
    }

    public enum Tab: String, CaseIterable, Equatable {
        case home = "Home"
        case settings = "Settings"

        public var systemImage: String {
            switch self {
            case .home: "house"
            case .settings: "gear"
            }
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.homeFeature, action: \.home) {
            HomeFeature()
        }

        Scope(state: \.settingsFeature, action: \.settings) {
            SettingsFeature()
        }

        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none

            case .home:
                return .none

            case .settings:
                return .none
            }
        }
    }
}

public struct RootView: View {
    @Bindable
    public var store: StoreOf<RootFeature>

    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }

    public var body: some View {
        TabView(selection: $store.selectedTab.sending(\.tabSelected)) {
            ForEach(RootFeature.Tab.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .home:
                        NavigationStack {
                            HomeView(
                                store: store.scope(state: \.homeFeature, action: \.home)
                            )
                        }
                    case .settings:
                        NavigationStack {
                            SettingsView(
                                store: store.scope(state: \.settingsFeature, action: \.settings)
                            )
                        }
                    }
                }
                .tabItem {
                    Image(systemName: tab.systemImage)
                    Text(tab.rawValue)
                }
                .tag(tab)
            }
        }
    }
}
