// ABOUTME: Testing utilities and mocks for CoreKit networking components
// ABOUTME: Provides test doubles and fixtures following TMA testing patterns

import ComposableArchitecture
import CoreKit
import Foundation

public extension NetworkClient {
    static let mockSuccess = NetworkClient(
        fetchPosts: {
            try await Task.sleep(nanoseconds: 10_000_000) // 10ms delay for realistic testing
            return TestData.samplePosts
        }
    )
    
    static let mockFailure = NetworkClient(
        fetchPosts: {
            try await Task.sleep(nanoseconds: 5_000_000) // 5ms delay
            throw NetworkError.networkError("Mock network failure for testing")
        }
    )
    
    static let mockTimeout = NetworkClient(
        fetchPosts: {
            try await Task.sleep(nanoseconds: 5_000_000) // 5ms delay
            throw NetworkError.networkError("Request timed out. Check your internet connection.")
        }
    )
    
    static let mockEmpty = NetworkClient(
        fetchPosts: { 
            try await Task.sleep(nanoseconds: 5_000_000) // 5ms delay
            return []
        }
    )
}

public struct TestData {
    public static let samplePosts = [
        Post(id: 1, title: "Sample Post 1", body: "First sample post for testing UI components.", userId: 1),
        Post(id: 2, title: "Sample Post 2", body: "Second sample post with longer body text to test how the UI handles varying content lengths and wrapping behavior.", userId: 2),
        Post(id: 3, title: "Sample Post 3", body: "Third sample post.", userId: 3),
    ]
    
    public static let longPost = Post(
        id: 999,
        title: "Very Long Title That Tests How The UI Handles Lengthy Content That Might Need Truncation Or Special Handling",
        body: "This is an extremely long post body that contains multiple sentences and should test how the UI components handle lengthy content. It includes various punctuation marks, numbers (123, 456), and should help verify that text wrapping, truncation, and accessibility features work correctly across different screen sizes and Dynamic Type settings. The content continues for quite a while to ensure we test edge cases in our UI rendering.",
        userId: 1
    )
}