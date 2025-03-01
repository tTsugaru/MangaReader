import Foundation

public struct MuComicPublisher: Codable, Sendable {
    public let muPublishers: MuPublishers

    enum CodingKeys: String, CodingKey {
        case muPublishers = "mu_publishers"
    }
}
