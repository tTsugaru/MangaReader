import Foundation

public struct ChapterNavigation: Hashable, Sendable {
    public let chapterId: String
    public let currentChapterImageId: String?

    public init(chapterId: String, currentChapterImageId: String? = nil) {
        self.chapterId = chapterId
        self.currentChapterImageId = currentChapterImageId
    }
}
