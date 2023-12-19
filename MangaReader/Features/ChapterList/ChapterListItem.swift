import Foundation

class ChapterListItem: ObservableObject, Identifiable {
    let id: String
    let title: String
    weak var parent: ChapterListItem?
    var children: [ChapterListItem]?
    
    @Published var showChildren = false
    
    init(id: String, title: String, parent: ChapterListItem? = nil, children: [ChapterListItem]? = nil) {
        self.id = id
        self.title = title
        self.parent = parent
        self.children = children
    }
}
extension ChapterListItem: Equatable {
    static func == (lhs: ChapterListItem, rhs: ChapterListItem) -> Bool {
        lhs.id == rhs.id
    }
}
extension ChapterListItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
