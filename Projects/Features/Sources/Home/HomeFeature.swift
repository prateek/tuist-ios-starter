// ABOUTME: Home feature that displays a list of posts from an API
// ABOUTME: Demonstrates TCA patterns including async effects, loading states, and error handling

import ComposableArchitecture
import CoreKit
import DesignSystem
import SwiftUI

@Reducer
public struct HomeFeature {
    @ObservableState
    public struct State: Equatable {
        public var posts: [Post] = []
        public var isLoading = false
        public var error: String?
        
        public init(
            posts: [Post] = [],
            isLoading: Bool = false,
            error: String? = nil
        ) {
            self.posts = posts
            self.isLoading = isLoading
            self.error = error
        }
    }
    
    public enum Action: Equatable {
        case onAppear
        case refreshButtonTapped
        case postsResponse(Result<[Post], NetworkError>)
    }
    
    @Dependency(\.networkClient) var networkClient
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .refreshButtonTapped:
                state.isLoading = true
                state.error = nil
                return .run { send in
                    await send(.postsResponse(
                        Result {
                            try await networkClient.fetchPosts()
                        }
                        .mapError { error in
                            if let networkError = error as? NetworkError {
                                return networkError
                            } else {
                                return NetworkError.unknown
                            }
                        }
                    ))
                }
                
            case let .postsResponse(.success(posts)):
                state.isLoading = false
                state.posts = posts
                return .none
                
            case let .postsResponse(.failure(error)):
                state.isLoading = false
                state.error = error.localizedDescription
                return .none
            }
        }
    }
}

public struct HomeView: View {
    @Bindable public var store: StoreOf<HomeFeature>
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Group {
            if store.isLoading && store.posts.isEmpty {
                LoadingView(message: LocalizedStrings.Loading.posts)
            } else if let error = store.error, store.posts.isEmpty {
                errorView(error)
            } else {
                postsListView
            }
        }
        .navigationTitle(LocalizedStrings.Navigation.home)
        .task {
            store.send(.onAppear)
        }
        .refreshable {
            store.send(.refreshButtonTapped)
        }
    }
    
    @ViewBuilder
    private var postsListView: some View {
        List {
            if store.isLoading {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text(LocalizedStrings.Loading.refreshing)
                        .body(.medium)
                        .foregroundColor(.textSecondary)
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
            
            ForEach(store.posts) { post in
                PostRowView(post: post)
                    .listRowSeparator(.visible)
            }
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private func errorView(_ error: String) -> some View {
        VStack(spacing: .spacingM) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.destructive)
            
            Text(LocalizedStrings.Error.somethingWentWrong)
                .heading(.medium)
            
            Text(error)
                .body(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(.textSecondary)
            
            PrimaryButton(LocalizedStrings.Common.retry) {
                store.send(.refreshButtonTapped)
            }
            .padding(.horizontal, .spacingXL)
        }
        .padding(.paddingL)
    }
}

private struct PostRowView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: .spacingS) {
            Text(post.title)
                .heading(.small)
                .lineLimit(2)
            
            Text(post.body)
                .body(.medium)
                .foregroundColor(.textSecondary)
                .lineLimit(3)
        }
        .padding(.vertical, .spacingXS)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Post: \(post.title). \(post.body)")
    }
}

#Preview("Home View - Loaded") {
    NavigationView {
        withDependencies {
            $0.networkClient = NetworkClient(
                fetchPosts: {
                    [
                        Post(id: 1, title: "Sample Post 1", body: "This is a sample post body that shows how posts will look in the app.", userId: 1),
                        Post(id: 2, title: "Another Post", body: "Here's another post with different content to show variety.", userId: 1)
                    ]
                }
            )
        } operation: {
            HomeView(
                store: Store(initialState: HomeFeature.State()) {
                    HomeFeature()
                }
            )
        }
    }
}

#Preview("Home View - Loading") {
    NavigationView {
        HomeView(
            store: Store(
                initialState: HomeFeature.State(isLoading: true)
            ) {
                HomeFeature()
            }
        )
    }
}

#Preview("Home View - Error") {
    NavigationView {
        HomeView(
            store: Store(
                initialState: HomeFeature.State(error: "Failed to load posts. Please check your internet connection.")
            ) {
                HomeFeature()
            }
        )
    }
}