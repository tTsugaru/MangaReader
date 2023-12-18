import Foundation

class ChapterListItem: ObservableObject, Identifiable {
    var id: String {
        UUID().uuidString
    }
    
    var title: String
    var children: [ChapterListItem]?
    
    @Published var showChildren = false
    
    init(title: String, children: [ChapterListItem]? = nil) {
        self.title = title
        self.children = children
    }
}
extension ChapterListItem: Equatable {
    static func == (lhs: ChapterListItem, rhs: ChapterListItem) -> Bool {
        lhs.id == rhs.id
    }
}
