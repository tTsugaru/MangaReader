import Foundation

public struct MUComics: Codable, Sendable {
    public let year: Int?
    public let muComicPublishers: [MuComicPublisher]
    public let licensedInEnglish: String?
    public let muComicCategories: [MUComicCategory]

    enum CodingKeys: String, CodingKey {
        case year
        case muComicPublishers = "mu_comic_publishers"
        case licensedInEnglish = "lincensed_in_english"
        case muComicCategories = "mu_comic_categories"
    }
}
