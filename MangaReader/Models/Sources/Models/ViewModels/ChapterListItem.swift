import Foundation

public struct ChapterListItem: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let mangaSlug: String
    public let parentId: String?
    public let children: [Self]?

    public init(id: String, title: String, parentId: String? = nil, mangaSlug: String, children: [Self]? = nil) {
        self.id = id
        self.title = title
        self.parentId = parentId
        self.mangaSlug = mangaSlug
        self.children = children
    }
}

extension ChapterListItem: Equatable {
    public static func == (lhs: ChapterListItem, rhs: ChapterListItem) -> Bool {
        lhs.id == rhs.id
    }
}
