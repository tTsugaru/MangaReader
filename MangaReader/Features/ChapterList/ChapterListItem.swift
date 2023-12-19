import Foundation

class ChapterListItem: ObservableObject, Identifiable {
    let id: String
    var title: String
    var children: [ChapterListItem]?
    
    @Published var showChildren = false
    
    init(id: String, title: String, children: [ChapterListItem]? = nil) {
        self.id = id
        self.title = title
        self.children = children
    }
}
extension ChapterListItem: Equatable {
    static func == (lhs: ChapterListItem, rhs: ChapterListItem) -> Bool {
        lhs.id == rhs.id
    }
}
