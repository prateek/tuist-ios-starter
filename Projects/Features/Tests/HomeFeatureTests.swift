// EXAMPLE_BEGIN: Home feature tests demonstration
// ABOUTME: Tests for HomeFeature demonstrating TCA testing patterns
// ABOUTME: Shows how to test async effects, success/failure paths, and dependency injection
// This is example code showing TCA testing patterns with TestStore and dependency injection

import ComposableArchitecture
import CoreKit
import CoreKitTesting
import DesignSystem
import FeaturesTesting
import XCTest
@testable import Features

final class HomeFeatureTests: XCTestCase {
    func testInitialState() {
        let store = HomeFeature.testStore()
        XCTAssertEqual(store.state.posts, [])
        XCTAssertFalse(store.state.isLoading)
        XCTAssertNil(store.state.error)
    }

    func testPostsResponseSuccess() async {
        let store = await TestStore(initialState: HomeFeature.State()) {
            HomeFeature()
        }

        await store.send(.postsResponse(.success(TestData.samplePosts))) {
            $0.isLoading = false
            $0.posts = TestData.samplePosts
        }
    }

    func testPostsResponseFailure() async {
        let store = await TestStore(initialState: HomeFeature.State()) {
            HomeFeature()
        }

        await store.send(.postsResponse(.failure(NetworkError.networkError("Test error")))) {
            $0.isLoading = false
            $0.error = "Network error: Test error"
        }
    }
}

// EXAMPLE_END
