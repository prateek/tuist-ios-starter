// ABOUTME: Network client for making API requests using modern Swift concurrency
// ABOUTME: Provides dependency injection for testability and includes live/test implementations

import ComposableArchitecture
import Foundation

public struct NetworkClient: Sendable {
    public var fetchPosts: @Sendable () async throws -> [Post]

    public init(fetchPosts: @escaping @Sendable () async throws -> [Post]) {
        self.fetchPosts = fetchPosts
    }
}

extension NetworkClient: DependencyKey {
    public static let liveValue = NetworkClient {
        // Check for local data flag (useful for demos and offline development)
        #if DEBUG
            if ProcessInfo.processInfo.environment["DEBUG_LOCAL_DATA"] == "1" {
                return try await loadLocalPosts()
            }
        #endif

        // Support environment variable for API base URL (useful for local development)
        let baseURL = ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "https://jsonplaceholder.typicode.com"
        guard let url = URL(string: "\(baseURL)/posts") else {
            throw NetworkError.invalidURL
        }

        // Configure URLSession for iOS Simulator reliability
        #if DEBUG && targetEnvironment(simulator)
            let config = URLSessionConfiguration.ephemeral // No disk cache
            config.urlCache = nil
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            config.waitsForConnectivity = true // Wait for network readiness
            config.timeoutIntervalForRequest = 15.0
            config.timeoutIntervalForResource = 30.0
        #else
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 15.0
            config.timeoutIntervalForResource = 30.0
        #endif
        let session = URLSession(configuration: config)

        // Implement retry logic with exponential backoff
        let maxRetries = 2
        var lastError: Error?

        for attempt in 0 ... maxRetries {
            do {
                let (data, response) = try await session.data(from: url)

                // Validate HTTP response
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200
                else {
                    throw NetworkError.networkError("Invalid response")
                }

                let posts = try JSONDecoder().decode([Post].self, from: data)
                return Array(posts.prefix(10)) // Limit to first 10 posts for demo
            } catch let decodingError as DecodingError {
                print("Decoding error: \(decodingError)")
                throw NetworkError.decodingError
            } catch {
                lastError = error
                if let urlError = error as? URLError {
                    print(
                        "Network attempt \(attempt + 1) failed: URLError(\(urlError.code.rawValue)) \(urlError.code) - \(urlError.localizedDescription)"
                    )
                } else {
                    print("Network attempt \(attempt + 1) failed: \(error)")
                }

                // Don't retry on final attempt
                if attempt < maxRetries {
                    // Exponential backoff: 300ms, 600ms
                    let delay = Double(300 * (attempt + 1)) / 1000.0
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
            }
        }

        // All retries failed
        if let urlError = lastError as? URLError {
            switch urlError.code {
            case .timedOut:
                throw NetworkError.networkError("Request timed out. Check your internet connection.")
            case .notConnectedToInternet:
                throw NetworkError.networkError("No internet connection available.")
            case .networkConnectionLost:
                throw NetworkError.networkError("Network connection was lost.")
            default:
                throw NetworkError.networkError("Network error: \(urlError.localizedDescription)")
            }
        } else {
            throw NetworkError.networkError(lastError?.localizedDescription ?? "Unknown network error")
        }
    }

    public static let testValue = NetworkClient {
        [
            Post(id: 1, title: "Test Post 1", body: "This is a test post body.", userId: 1),
            Post(id: 2, title: "Test Post 2", body: "Another test post body.", userId: 1),
        ]
    }

    public static let previewValue = testValue
}

public extension DependencyValues {
    var networkClient: NetworkClient {
        get { self[NetworkClient.self] }
        set { self[NetworkClient.self] = newValue }
    }
}

// MARK: - Local Data Support

private func loadLocalPosts() async throws -> [Post] {
    guard let url = Bundle.main.url(forResource: "posts", withExtension: "json") else {
        throw NetworkError.invalidURL
    }

    do {
        let data = try Data(contentsOf: url)
        let posts = try JSONDecoder().decode([Post].self, from: data)

        // Simulate network delay for realistic demo experience
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

        return posts
    } catch {
        print("Failed to load local posts: \(error)")
        throw NetworkError.decodingError
    }
}
