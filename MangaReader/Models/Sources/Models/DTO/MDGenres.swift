import Foundation

public struct MDGenres: Codable, Sendable {
    public let name: String
    public let type: String?
    public let slug: String
    public let group: String
}
