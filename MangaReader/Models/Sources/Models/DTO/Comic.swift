import Foundation

public struct Comic: Codable, Sendable {
    public let id: Int
    public let hid: String
    public let title: String
    public let country: String?
    public let status: Int
    public let links: Links?
    public let lastChapter: Double
    public let chapterCount: Int
    public let demographic: Int?
    public let hentai: Bool?
    public let userFollowCount: Int
    public let followRank: Int?
    public let commentCount: Int
    public let followCount: Int
    public let description: String?
    public let parsedDescription: String?
    public let slug: String
    public let mismatch: String?
    public let year: Int
    public let bayesianRating: String?
    public let ratingCount: Int
    public let contentRating: String
    public let translationCompleted: Bool
    public let chapterNumbersResetOnNewVolumeManual: Bool
    public let finalChapter: String?
    public let finalVolume: String?
    public let noindex: Bool
    public let relateFrom: [RelateFrom]
    public let mdTitles: [MDTitle]
    public let mdComicMdGenres: [MDComicMDGenre]
    public let mdCovers: [Cover]
    public let muComics: MUComics
    public let countryCode: String?
    public let langName: String?
    public let langNative: String?
    public let coverUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case hid
        case title
        case country
        case status
        case links
        case lastChapter = "last_chapter"
        case chapterCount = "chapter_count"
        case demographic
        case hentai
        case userFollowCount = "user_follow_count"
        case followRank = "follow_rank"
        case commentCount = "comment_count"
        case followCount = "follow_count"
        case description = "desc"
        case parsedDescription = "parsed"
        case slug
        case mismatch
        case year
        case bayesianRating = "bayesian_rating"
        case ratingCount = "rating_count"
        case contentRating = "content_rating"
        case translationCompleted = "translation_completed"
        case chapterNumbersResetOnNewVolumeManual = "chapter_numbers_reset_on_new_volume_manual"
        case finalChapter = "first_chapter"
        case finalVolume = "final_colume"
        case noindex
        case relateFrom = "relate_from"
        case mdTitles = "md_titles"
        case mdComicMdGenres = "md_comic_md_genres"
        case mdCovers = "md_covers"
        case muComics = "mu_comics"
        case countryCode = "iso639_1"
        case langName = "lang_name"
        case langNative = "lang_native"
        case coverUrl = "cover_url"
    }
}
