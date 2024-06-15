import Foundation

struct ChapterListItem: Identifiable, Hashable {
    let id: String
    let title: String
    let mangaSlug: String
    let parentId: String?
    let children: [ChapterListItem]?
    
    init(id: String, title: String, parentId: String? = nil, mangaSlug: String, children: [ChapterListItem]? = nil) {
        self.id = id
        self.title = title
        self.parentId = parentId
        self.mangaSlug = mangaSlug
        self.children = children
    }
}
extension ChapterListItem: Equatable {
    static func == (lhs: ChapterListItem, rhs: ChapterListItem) -> Bool {
        lhs.id == rhs.id
    }
}
