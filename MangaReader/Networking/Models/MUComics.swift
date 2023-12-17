import Foundation

struct Categorie: Codable {
    let title: String
    let slug: String
}
struct MUComicCategorie: Codable {
    let muCategories: Categorie
    let upVote: Int
    let downVote: Int
    
    enum CodingKeys: String, CodingKey {
        case muCategories = "mu_categories"
        case upVote = "positive_vote"
        case downVote = "negative_vote"
    }
}
struct MUComics: Codable {
    let year: Int?
    let muComicPublishers: [MuComicPublisher]
    let licensedInEnglish: String?
    let muComicCategories: [MUComicCategorie]
    
    enum CodingKeys: String, CodingKey {
        case year
        case muComicPublishers = "mu_comic_publishers"
        case licensedInEnglish = "lincensed_in_english"
        case muComicCategories = "mu_comic_categories"
    }
}

struct MuComicPublisher: Codable {
    let muPublishers: MuPublishers
    
    enum CodingKeys: String, CodingKey {
        case muPublishers = "mu_publishers"
    }
}

struct MuPublishers: Codable {
    let title: String
    let slug: String
}
