import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Creates a new feature following TMA 3-target pattern",
    attributes: [
        nameAttribute,
        .optional("platform", default: "iOS"),
    ],
    items: [
        // Feature Source Implementation
        .string(
            path: "Projects/Features/Sources/\(nameAttribute)/\(nameAttribute)Feature.swift",
            contents: """
            // ABOUTME: \(nameAttribute) feature implementing TCA patterns
            // ABOUTME: Contains state management, actions, and view implementation

            import ComposableArchitecture
            import CoreKit
            import DesignSystem
            import SwiftUI

            @Reducer
            public struct \(nameAttribute)Feature {
                @ObservableState
                public struct State: Equatable {
                    public var isLoading = false
                    public var error: String?
                    
                    public init(
                        isLoading: Bool = false,
                        error: String? = nil
                    ) {
                        self.isLoading = isLoading
                        self.error = error
                    }
                }
                
                public enum Action: Equatable {
                    case onAppear
                    case refreshButtonTapped
                    // Add feature-specific actions here
                }
                
                public init() {}
                
                public var body: some ReducerOf<Self> {
                    Reduce { state, action in
                        switch action {
                        case .onAppear:
                            // Implement feature logic
                            return .none
                            
                        case .refreshButtonTapped:
                            // Implement refresh logic
                            return .none
                        }
                    }
                }
            }

            public struct \(nameAttribute)View: View {
                @Bindable public var store: StoreOf<\(nameAttribute)Feature>
                
                public init(store: StoreOf<\(nameAttribute)Feature>) {
                    self.store = store
                }
                
                public var body: some View {
                    VStack {
                        Text("\(nameAttribute) Feature")
                            .heading(.large)
                        
                        if store.isLoading {
                            LoadingView(message: "Loading...")
                        } else if let error = store.error {
                            Text("Error: \\(error)")
                                .foregroundColor(.destructive)
                        } else {
                            Text("Feature content goes here")
                                .body(.medium)
                        }
                        
                        PrimaryButton("Refresh") {
                            store.send(.refreshButtonTapped)
                        }
                    }
                    .padding()
                    .navigationTitle("\(nameAttribute)")
                    .task {
                        store.send(.onAppear)
                    }
                }
            }

            #Preview("\(nameAttribute) View") {
                NavigationStack {
                    \(nameAttribute)View(
                        store: Store(initialState: \(nameAttribute)Feature.State()) {
                            \(nameAttribute)Feature()
                        }
                    )
                }
            }
            """
        ),
        
        // Feature Tests
        .string(
            path: "Projects/Features/Tests/\(nameAttribute)FeatureTests.swift",
            contents: """
            // ABOUTME: Tests for \(nameAttribute)Feature using TMA testing patterns
            // ABOUTME: Demonstrates TCA testing with mocks and dependency injection

            import ComposableArchitecture
            import CoreKit
            import CoreKitTesting
            import FeaturesTesting
            import XCTest
            @testable import Features

            final class \(nameAttribute)FeatureTests: XCTestCase {
                
                func testOnAppear() async {
                    let store = \(nameAttribute)Feature.testStore()
                    
                    await store.send(.onAppear)
                }
                
                func testRefreshButton() async {
                    let store = \(nameAttribute)Feature.testStore()
                    
                    await store.send(.refreshButtonTapped)
                }
            }
            """
        ),
        
        // Feature Testing Utilities
        .string(
            path: "Projects/Features/Testing/Sources/\(nameAttribute)Testing.swift",
            contents: """
            // ABOUTME: Testing utilities for \(nameAttribute)Feature following TMA patterns
            // ABOUTME: Provides test stores and mock states for \(nameAttribute) testing

            import ComposableArchitecture
            import Features
            import Foundation

            public extension \(nameAttribute)Feature {
                static func testStore(
                    initialState: State = State()
                ) -> TestStore<State, Action> {
                    TestStore(initialState: initialState) {
                        \(nameAttribute)Feature()
                    }
                }
            }

            public extension MockStates {
                static let \(nameAttribute)Default = \(nameAttribute)Feature.State()
                static let \(nameAttribute)Loading = \(nameAttribute)Feature.State(isLoading: true)
                static let \(nameAttribute)WithError = \(nameAttribute)Feature.State(error: "Test error")
            }
            """
        ),
    ]
)