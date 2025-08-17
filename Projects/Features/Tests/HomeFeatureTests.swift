// ABOUTME: Tests for HomeFeature demonstrating TCA testing patterns
// ABOUTME: Shows how to test async effects, success/failure paths, and dependency injection

import ComposableArchitecture
import CoreKit
import CoreKitTesting
import FeaturesTesting
import XCTest
@testable import Features

final class HomeFeatureTests: XCTestCase {
    
    func testLoadPostsSuccess() async {
        let store = HomeFeature.testStore(
            networkClient: NetworkClient.mockSuccess
        )
        
        await store.send(.onAppear) {
            $0.isLoading = true
            $0.error = nil
        }
        
        await store.receive(\.postsResponse.success) {
            $0.isLoading = false
            $0.posts = TestData.samplePosts
        }
    }
    
    func testLoadPostsFailure() async {
        let store = HomeFeature.testStore(
            networkClient: NetworkClient.mockFailure
        )
        
        await store.send(.refreshButtonTapped) {
            $0.isLoading = true
            $0.error = nil
        }
        
        await store.receive(\.postsResponse.failure) {
            $0.isLoading = false
            $0.error = "Network error: Mock network failure for testing"
        }
    }
    
    func testRefreshClearsError() async {
        let store = HomeFeature.testStore(
            initialState: HomeFeature.State(error: "Previous error"),
            networkClient: NetworkClient.mockEmpty
        )
        
        await store.send(.refreshButtonTapped) {
            $0.isLoading = true
            $0.error = nil
        }
        
        await store.receive(\.postsResponse.success) {
            $0.isLoading = false
            $0.posts = []
        }
    }
}