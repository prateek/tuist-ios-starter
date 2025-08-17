// ABOUTME: Tests for NetworkError enum
// ABOUTME: Verifies error descriptions and equality behavior

import XCTest
@testable import CoreKit

final class NetworkErrorTests: XCTestCase {
    func testErrorDescriptions() {
        XCTAssertEqual(NetworkError.invalidURL.localizedDescription, "Invalid URL")
        XCTAssertEqual(NetworkError.noData.localizedDescription, "No data received")
        XCTAssertEqual(NetworkError.decodingError.localizedDescription, "Failed to decode response")
        XCTAssertEqual(NetworkError.networkError("Custom error").localizedDescription, "Network error: Custom error")
        XCTAssertEqual(NetworkError.unknown.localizedDescription, "An unknown error occurred")
    }

    func testNetworkErrorEquality() {
        XCTAssertEqual(NetworkError.invalidURL, NetworkError.invalidURL)
        XCTAssertEqual(NetworkError.networkError("test"), NetworkError.networkError("test"))
        XCTAssertNotEqual(NetworkError.invalidURL, NetworkError.noData)
        XCTAssertNotEqual(NetworkError.networkError("test1"), NetworkError.networkError("test2"))
    }
}
