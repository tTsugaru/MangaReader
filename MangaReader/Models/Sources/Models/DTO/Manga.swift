import Foundation

public struct Manga: Codable, Sendable {
    public let id: Int
    public let hid: String
    public let slug: String
    public let title: String
    public let rating: String?
    public let bayesianRating: String?
    public let ratingCount: Int?
    public let followCount: Int?
    public let desc: String?
    public let status: Int
    public let lastChapter: Double?
    public let translationCompleted: Bool?
    public let viewCount: Int?
    public let contentRating: String?
    public let demographic: Int?
    public let genres: [Int]
    public let createdAt: String?
    public let userFollowCount: Int?
    public let year: Int?
    public let mdTitles: [MDTitle]?
    public let covers: [Cover]?
    public let muComics: MUComics?
    public let coverURL: String?
    
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
