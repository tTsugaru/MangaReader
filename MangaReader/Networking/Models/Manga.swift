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
    let desc: String
    let status: Int
    let lastChapter: Double?
    let translationCompleted: Bool?
    let viewCount: Int?
    let contentRating: String?
    let demographic: Int?
    let genres: [Int]
    let createdAt: String?
    let userFollowCount: Int?
    let year: Int
    let mdTitles: [MDTitle]?
    let mdCovers: [Cover]?
    let muComics: MUComics?
    let coverUrl: String?
}
