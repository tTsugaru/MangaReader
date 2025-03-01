import Foundation

public struct ChapterDetailResponse: Codable, Sendable {
    public let chapter: ChapterDetail
    public let next: NextChapter?
    public let chapTitle: String?
}
