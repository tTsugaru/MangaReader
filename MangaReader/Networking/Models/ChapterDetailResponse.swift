import Foundation

struct NextChapter: Codable {
    let hid: String
}
struct ChapterDetailResponse: Codable {
    let chapter: ChapterDetail
    let next: NextChapter?
    let chapTitle: String?
}

struct ChapterDetail: Codable {
    let id: Int
    let chap: String
    let vol: String?
    let title: String?
    let hid: String
    let groupName: [String]
    let chapterId: Int?
    let createdAt, updatedAt: String
    let crawledAt: String?
    let mdid: String?
    let commentCount, upCount, downCount: Int
    let status: String
    let adsense: Bool
    let lang: String
    let mdComics: MdComics
    let mdChaptersGroups: [MdChaptersGroup]?
    let genres: [Int]?
    let contentRating: String?
    let chapterNumbersResetOnNewVolumeManual: Bool?
    let noindex: Bool?
    let coverUrl: String?
    let images: [ChapterImage]?
    
    enum CodingKeys: String, CodingKey {
        case id, chap, vol, title, hid
        case groupName = "group_name"
        case chapterId = "chapter_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case crawledAt = "crawled_at"
        case mdid
        case commentCount = "comment_count"
        case upCount = "up_count"
        case downCount = "down_count"
        case status, adsense, lang
        case mdComics = "md_comics"
        case mdChaptersGroups = "md_chapters_groups"
        case genres
        case contentRating = "content_rating"
        case chapterNumbersResetOnNewVolumeManual = "chapter_numbers_reset_on_new_volume_manual"
        case noindex
        case coverUrl = "cover_url"
        case images
    }
}

struct MdComics: Codable {
    let id: Int
    let title, country, slug, desc: String
    let links: MdComicLinks
    let genres: [Int]
    let hid, contentRating: String
    let chapterNumbersResetOnNewVolumeManual: Bool
    let noindex: Bool
    let muComics: MuComics
    
    enum CodingKeys: String, CodingKey {
        case id, title, country, slug, desc, links, genres, hid
        case contentRating = "content_rating"
        case chapterNumbersResetOnNewVolumeManual = "chapter_numbers_reset_on_new_volume_manual"
        case noindex
        case muComics = "mu_comics"
    }
}

struct MdComicLinks: Codable {
    let al, ap, bw, kt: String?
    let mu, amz, cdj, ebj: String?
    let mal, raw, engtl: String?
}

struct MuComics: Codable {
    let muComicPublishers: [MuComicPublishers]
    
    enum CodingKeys: String, CodingKey {
        case muComicPublishers = "mu_comic_publishers"
    }
}

struct MuComicPublishers: Codable {
    let muPublishers: MuPublisherss
    
    enum CodingKeys: String, CodingKey {
        case muPublishers = "mu_publishers"
    }
}

struct MuPublisherss: Codable {
    let title, slug: String
}

struct ChapterImage: Codable {
    let url: String
    let w, h: Int
}
