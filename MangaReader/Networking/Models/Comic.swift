import Foundation

struct Comic: Codable {
    let id: Int
    let hid: String
    let title: String
    let country: String
    let status: Int
    let links: Links
    let lastChapter: Int
    let chapterCount: Int
    let demographic: String?
    let hentai: Bool
    let userFollowCount: Int
    let followRank: Int?
    let commentCount: Int
    let followCount: Int
    let desc: String
    let parsed: String
    let slug: String
    let mismatch: String?
    let year: Int
    let bayesianRating: Double?
    let ratingCount: Int
    let contentRating: String
    let translationCompleted: Bool
    let chapterNumbersResetOnNewVolumeManual: Bool
    let finalChapter: String?
    let finalVolume: String?
    let noindex: Bool
    let relateFrom: [String]
    let mdTitles: [MDTitle]
    let mdComicMdGenres: [MDComicMDGenre]
    let mdCovers: [Cover]
    let muComics: MUComics
    let iso639_1: String
    let langName: String
    let langNative: String
    let coverUrl: String
}
