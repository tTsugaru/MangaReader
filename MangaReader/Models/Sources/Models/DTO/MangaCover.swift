import Foundation

public struct MangaCover: Codable, Sendable {
    public let width: Int
    public let height: Int
    public let b2key: String

    enum CodingKeys: String, CodingKey {
        case width = "w"
        case height = "h"
        case b2key
    }
}
