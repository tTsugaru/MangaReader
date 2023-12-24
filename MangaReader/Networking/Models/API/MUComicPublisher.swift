import Foundation

struct MuComicPublisher: Codable {
    let muPublishers: MuPublishers

    enum CodingKeys: String, CodingKey {
        case muPublishers = "mu_publishers"
    }
}
