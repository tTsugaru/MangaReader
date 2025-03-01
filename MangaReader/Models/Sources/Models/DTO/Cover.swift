import Foundation

public struct Cover: Codable, Sendable {
    public let vol: String?
    public let width: Int?
    public let height: Int?
    public let b2key: String?

    enum CodingKeys: String, CodingKey {
        case vol
        case width = "w"
        case height = "h"
        case b2key
    }
}
