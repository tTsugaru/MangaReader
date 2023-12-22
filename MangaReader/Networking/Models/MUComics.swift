import Foundation

struct MUComics: Codable {
    let year: Int?
    let muComicPublishers: [MuComicPublisher]
    let licensedInEnglish: String?
    let muComicCategories: [MUComicCategory]
    
    enum CodingKeys: String, CodingKey {
        case year
        case muComicPublishers = "mu_comic_publishers"
        case licensedInEnglish = "lincensed_in_english"
        case muComicCategories = "mu_comic_categories"
    }
}


