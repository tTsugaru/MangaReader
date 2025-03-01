import SwiftData
import SwiftUI
import MangaList
import Models
import Styles
import History

public struct NavigationView: View {
    
    @EnvironmentObject private var theme: Theme
    
    public init() {}
    
    public var body: some View {
        TabView {
            Tab("List", systemImage: "list") {
                MangaListScreen(viewModel: MangaListViewModel())
            }

            Tab("Favorites", systemImage: "star.fill") {
                Text("Under construction...")
            }

            Tab("History", systemImage: "clock") {
                HistoryScreen()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tint(theme.toolbarTint)
    }
}

#Preview() {
    NavigationView()
        .environmentObject(Theme())
}
