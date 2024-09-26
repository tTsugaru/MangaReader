import SwiftData
import SwiftUI

struct NavigationView: View {
    
    @State private var historyStackPath = NavigationPath()
    
    @StateObject var listViewModel = MangaListViewModel()
    
    var body: some View {
        TabView {
            Tab("List", systemImage: "list") {
                MangaListScreen(viewModel: listViewModel)
            }

            Tab("Favorites", systemImage: "star.fill") {
                Text("I bims a tab2")
            }

            Tab("History", systemImage: "clock") {
                HistoryScreen(path: $historyStackPath)
            }

        }
        .tabViewStyle(.sidebarAdaptable)
    }
}
