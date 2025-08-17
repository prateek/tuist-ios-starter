// ABOUTME: Tests for NetworkClient dependency
// ABOUTME: Demonstrates how to test dependencies and their different implementations

import XCTest
@testable import CoreKit

final class NetworkClientTests: XCTestCase {
    func testTestValueReturnsExpectedPosts() async throws {
        let client = NetworkClient.testValue
        let posts = try await client.fetchPosts()

        XCTAssertEqual(posts.count, 2)
        XCTAssertEqual(posts[0].id, 1)
        XCTAssertEqual(posts[0].title, "Test Post 1")
        XCTAssertEqual(posts[1].id, 2)
        XCTAssertEqual(posts[1].title, "Test Post 2")
    }

    func testPreviewValueIsSameAsTestValue() async throws {
        let testClient = NetworkClient.testValue
        let previewClient = NetworkClient.previewValue

        let testPosts = try await testClient.fetchPosts()
        let previewPosts = try await previewClient.fetchPosts()

        XCTAssertEqual(testPosts, previewPosts)
    }
}
