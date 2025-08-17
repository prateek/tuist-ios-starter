// ABOUTME: Settings feature demonstrating various input types and navigation patterns
// ABOUTME: Shows form handling, alerts, and local state management using TCA

import ComposableArchitecture
import DesignSystem
import SwiftUI

@Reducer
public struct SettingsFeature {
    @ObservableState
    public struct State: Equatable {
        public var notificationsEnabled = true
        public var selectedTheme: Theme = .system
        public var username = ""
        @Presents public var alert: AlertState<Action.Alert>?
        
        public init(
            notificationsEnabled: Bool = true,
            selectedTheme: Theme = .system,
            username: String = "",
            alert: AlertState<Action.Alert>? = nil
        ) {
            self.notificationsEnabled = notificationsEnabled
            self.selectedTheme = selectedTheme
            self.username = username
            self.alert = alert
        }
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case notificationsToggleChanged(Bool)
        case themeChanged(Theme)
        case saveButtonTapped
        case resetButtonTapped
        case alert(PresentationAction<Alert>)
        
        public enum Alert: Equatable {
            case confirmReset
        }
    }
    
    public enum Theme: String, CaseIterable, Equatable {
        case light = "Light"
        case dark = "Dark"
        case system = "System"
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case let .notificationsToggleChanged(isEnabled):
                state.notificationsEnabled = isEnabled
                return .none
                
            case let .themeChanged(theme):
                state.selectedTheme = theme
                return .none
                
            case .saveButtonTapped:
                // In a real app, this would save to UserDefaults or server
                state.alert = AlertState {
                    TextState(LocalizedStrings.Settings.settingsSaved)
                } actions: {
                    ButtonState {
                        TextState(LocalizedStrings.Common.ok)
                    }
                } message: {
                    TextState(LocalizedStrings.Settings.settingsSavedMessage)
                }
                return .none
                
            case .resetButtonTapped:
                state.alert = AlertState {
                    TextState(LocalizedStrings.Settings.resetSettings)
                } actions: {
                    ButtonState(action: .confirmReset) {
                        TextState(LocalizedStrings.Common.reset)
                    }
                    ButtonState(role: .cancel) {
                        TextState(LocalizedStrings.Common.cancel)
                    }
                } message: {
                    TextState(LocalizedStrings.Settings.resetConfirmation)
                }
                return .none
                
            case .alert(.presented(.confirmReset)):
                state.notificationsEnabled = true
                state.selectedTheme = .system
                state.username = ""
                return .none
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

public struct SettingsView: View {
    @Bindable public var store: StoreOf<SettingsFeature>
    
    public init(store: StoreOf<SettingsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Form {
            Section {
                HStack {
                    Text(LocalizedStrings.Settings.username)
                        .body(.medium)
                    TextField(LocalizedStrings.Settings.enterUsername, text: $store.username)
                        .textFieldStyle(.roundedBorder)
                }
            } header: {
                Text(LocalizedStrings.Settings.profile)
            }
            
            Section {
                Toggle(LocalizedStrings.Settings.pushNotifications, isOn: $store.notificationsEnabled)
                    .body(.medium)
                
                HStack {
                    Text(LocalizedStrings.Settings.theme)
                        .body(.medium)
                    Spacer()
                    Picker(LocalizedStrings.Settings.theme, selection: $store.selectedTheme) {
                        ForEach(SettingsFeature.Theme.allCases, id: \.self) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    .pickerStyle(.menu)
                }
            } header: {
                Text(LocalizedStrings.Settings.preferences)
            }
            
            Section {
                PrimaryButton(LocalizedStrings.Settings.saveSettings) {
                    store.send(.saveButtonTapped)
                }
                
                PrimaryButton(LocalizedStrings.Settings.resetToDefaults, style: .outlined) {
                    store.send(.resetButtonTapped)
                }
            }
        }
        .navigationTitle(LocalizedStrings.Settings.title)
        .alert(store: store.scope(state: \.$alert, action: \.alert))
    }
}

#Preview("Settings View") {
    NavigationView {
        SettingsView(
            store: Store(initialState: SettingsFeature.State()) {
                SettingsFeature()
            }
        )
    }
}

#Preview("Settings View - Custom State") {
    NavigationView {
        SettingsView(
            store: Store(
                initialState: SettingsFeature.State(
                    notificationsEnabled: false,
                    selectedTheme: .dark,
                    username: "claude_dev"
                )
            ) {
                SettingsFeature()
            }
        )
    }
}