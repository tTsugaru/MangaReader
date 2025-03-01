import Foundation

public struct MangaDetail: Codable, Sendable {
    public let firstChap: FirstChapter
    public let comic: Comic
    public let artists: [Artist]?
    public let authors: [Author]?
    public let langList: [String]
    public let demographic: String?
    public let englishLink: String?
    public let matureContent: Bool
    public let checkVol2Chap1: Bool
}
