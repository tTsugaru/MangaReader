import Foundation

struct Comic: Codable {
    let id: Int
    let hid: String
    let title: String
    let country: String
    let status: Int
    let links: Links?
    let lastChapter: Int
    let chapterCount: Int
    let demographic: Int?
    let hentai: Bool
    let userFollowCount: Int
    let followRank: Int?
    let commentCount: Int
    let followCount: Int
    let description: String
    let parsedDescription: String
    let slug: String
    let mismatch: String?
    let year: Int
    let bayesianRating: String?
    let ratingCount: Int
    let contentRating: String
    let translationCompleted: Bool
    let chapterNumbersResetOnNewVolumeManual: Bool
    let finalChapter: String?
    let finalVolume: String?
    let noindex: Bool
    let relateFrom: [RelateFrom]
    let mdTitles: [MDTitle]
    let mdComicMdGenres: [MDComicMDGenre]
    let mdCovers: [Cover]
    let muComics: MUComics
    let countryCode: String
    let langName: String?
    let langNative: String?
    let coverUrl: String
    
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
