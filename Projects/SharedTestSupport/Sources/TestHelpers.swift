// ABOUTME: Shared test utilities and helpers for consistent testing across modules
// ABOUTME: Provides common test data, mocks, and utility functions

import ComposableArchitecture
import CoreKit
import Foundation

// MARK: - Test Data Factories

public enum TestData {
    public static func samplePosts(count: Int = 3) -> [Post] {
        (1...count).map { index in
            Post(
                id: index,
                title: "Sample Post \(index)",
                body: "This is the body content for sample post number \(index). It contains some example text to demonstrate how posts will appear in the app.",
                userId: 1
            )
        }
    }
    
    public static func longPost() -> Post {
        Post(
            id: 999,
            title: "This is a very long post title that might wrap to multiple lines in the UI to test how the layout handles longer content",
            body: """
            This is a very long post body that contains multiple paragraphs and extensive content to test how the UI handles longer text content.
            
            It includes line breaks and various formatting to ensure that the UI can properly display and handle posts with substantial amounts of text content.
            
            This helps us verify that our layout constraints and text handling work correctly across different content lengths and sizes.
            """,
            userId: 1
        )
    }
    
    public static func emptyPost() -> Post {
        Post(id: 0, title: "", body: "", userId: 0)
    }
}

// MARK: - Mock Network Client

public extension NetworkClient {
    static func mock(
        posts: [Post] = TestData.samplePosts(),
        shouldFail: Bool = false,
        error: NetworkError = .unknown
    ) -> NetworkClient {
        NetworkClient(
            fetchPosts: {
                if shouldFail {
                    throw error
                }
                return posts
            }
        )
    }
    
    static let alwaysFails = NetworkClient(
        fetchPosts: {
            throw NetworkError.networkError("Mock network failure")
        }
    )
    
    static let empty = NetworkClient(
        fetchPosts: { [] }
    )
}

// MARK: - Test Store Helpers

public extension TestStore {
    /// Convenience method to send an action and wait for it to complete
    func sendAndWait(_ action: Action) async {
        await self.send(action)
    }
}