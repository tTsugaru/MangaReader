import Foundation

struct Manga: Codable {
    let id: Int
    let hid: String
    let slug: String
    let title: String
    let rating: String
    let bayesian_rating: String
    let rating_count: Int
    let follow_count: Int
    let desc: String
    let status: Int
    let last_chapter: Int
    let translation_completed: Bool
    let view_count: Int
    let content_rating: String
    let demographic: Int?
    let genres: [Int]
    let created_at: String
    let user_follow_count: Int
    let year: Int
    let md_titles: [MDTitle]
    let md_covers: [Cover]
    let mu_comics: MUComics
    let cover_url: String
}

struct MDTitle: Codable {
    let title: String
}

struct Cover: Codable {
    let w: Int
    let h: Int
    let b2key: String
}

struct MUComics: Codable {
    let year: Int
}
