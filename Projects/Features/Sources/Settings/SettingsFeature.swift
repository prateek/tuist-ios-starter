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
                    TextState("Settings Saved")
                } actions: {
                    ButtonState {
                        TextState("OK")
                    }
                } message: {
                    TextState("Your settings have been saved successfully.")
                }
                return .none
                
            case .resetButtonTapped:
                state.alert = AlertState {
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
                    Text("Username")
                        .body(.medium)
                    TextField("Enter username", text: $store.username)
                        .textFieldStyle(.roundedBorder)
                }
            } header: {
                Text("Profile")
            }
            
            Section {
                Toggle("Push Notifications", isOn: $store.notificationsEnabled)
                    .body(.medium)
                
                HStack {
                    Text("Theme")
                        .body(.medium)
                    Spacer()
                    Picker("Theme", selection: $store.selectedTheme) {
                        ForEach(SettingsFeature.Theme.allCases, id: \.self) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    .pickerStyle(.menu)
                }
            } header: {
                Text("Preferences")
            }
            
            Section {
                PrimaryButton("Save Settings") {
                    store.send(.saveButtonTapped)
                }
                
                PrimaryButton("Reset to Defaults", style: .outlined) {
                    store.send(.resetButtonTapped)
                }
            }
        }
        .navigationTitle("Settings")
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