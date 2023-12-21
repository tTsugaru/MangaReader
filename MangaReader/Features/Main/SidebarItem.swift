import SwiftUI

enum SidebarItem: Int, Identifiable, CaseIterable {
    var id: Int { rawValue }

    case list
    case favorites

    var title: String {
        switch self {
        case .list: "List"
        case .favorites: "Favorites"
        }
    }

    var icon: Image {
        switch self {
        case .list:
            Image(systemName: "books.vertical")
        case .favorites:
            Image(systemName: "star")
        }
    }
}
