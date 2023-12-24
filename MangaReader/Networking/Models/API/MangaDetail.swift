import Foundation

struct MangaDetail: Codable {
    let firstChap: FirstChapter
    let comic: Comic
    let artists: [Artist]?
    let authors: [Author]?
    let langList: [String]
    let demographic: String?
    let englishLink: String?
    let matureContent: Bool
    let checkVol2Chap1: Bool
}

