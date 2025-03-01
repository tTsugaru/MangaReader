import Foundation

public struct ChapterResponse: Codable, Sendable {
    public let chapters: [Chapter]
    public let total: Int
    public let limit: Int
}
