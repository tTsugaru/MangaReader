import Foundation

struct Manga: Codable {
    let id: Int
    let hid: String
    let slug: String
    let title: String
    let rating: String?
    let bayesianRating: String?
    let ratingCount: Int?
    let followCount: Int?
    let desc: String?
    let status: Int
    let lastChapter: Double?
    let translationCompleted: Bool?
    let viewCount: Int?
    let contentRating: String?
    let demographic: Int?
    let genres: [Int]
    let createdAt: String?
    let userFollowCount: Int?
    let year: Int?
    let mdTitles: [MDTitle]?
    let covers: [Cover]?
    let muComics: MUComics?
    let coverURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case hid
        case slug
        case title
        case rating
        case bayesianRating = "bayesian_rating"
        case ratingCount = "rating_count"
        case followCount = "follow_count"
        case desc = "description"
        case status = "status"
        case lastChapter = "last_chapter"
        case translationCompleted = "translation_completed"
        case viewCount = "view_count"
        case contentRating = "content_Rating"
        case demographic
        case genres
        case createdAt = "created_at"
        case userFollowCount = "user_follow_count"
        case year
        case mdTitles = "md_titles"
        case covers = "md_covers"
        case muComics = "md_comics"
        case coverURL = "cover_url"
    }
}
