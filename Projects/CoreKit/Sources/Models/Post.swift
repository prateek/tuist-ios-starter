// ABOUTME: Defines the Post model for demonstration purposes
// ABOUTME: Used by the Home feature to display a list of posts from an API

import Foundation

public struct Post: Codable, Identifiable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let body: String
    public let userId: Int

    public init(id: Int, title: String, body: String, userId: Int) {
        self.id = id
        self.title = title
        self.body = body
        self.userId = userId
    }
}
