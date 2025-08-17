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
            "Invalid URL" // TODO: Localize when L10n infrastructure is added
        case .noData:
            "No data received" // TODO: Localize when L10n infrastructure is added
        case .decodingError:
            "Failed to decode response" // TODO: Localize when L10n infrastructure is added
        case .networkError(let message):
            "Network error: \(message)" // TODO: Localize when L10n infrastructure is added
        case .unknown:
            "An unknown error occurred" // TODO: Localize when L10n infrastructure is added
        }
    }
}
