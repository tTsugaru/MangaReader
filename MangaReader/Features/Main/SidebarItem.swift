import SwiftUI

enum SidebarItem: Int, Identifiable, CaseIterable {
    var id: Int { rawValue }

    case list
    case favorites
    case history

    var title: String {
        switch self {
        case .list: "List"
        case .favorites: "Favorites"
        case .history: "History"
        }
    }

    var icon: Image {
        switch self {
        case .list:
            Image(systemName: "books.vertical")
        case .favorites:
            Image(systemName: "star")
        case .history:
            Image(systemName: "clock")
        }
    }
}
