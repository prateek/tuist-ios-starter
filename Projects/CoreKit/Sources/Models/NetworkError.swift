// ABOUTME: Defines common network errors for the application
// ABOUTME: Used throughout the app for consistent error handling

import Foundation

public enum NetworkError: Error, Equatable, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(String)
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let message):
            return "Network error: \(message)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}