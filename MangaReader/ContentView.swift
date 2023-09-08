import SwiftData
import SwiftUI

struct ContentView: View {
    @StateObject var listViewModel = MangaListViewModel()
    @State var defaultSelection = 0

    var body: some View {
        #if os(iOS)
            TabView {
                MangaListScreen(viewModel: listViewModel)
                    .tabItem {
                        Label("Mangas", systemImage: "books.vertical")
                    }

                Text("Favorites")
                    .tabItem {
                        Label("Favorites", systemImage: "star")
                    }
            }
        #else
            NavigationSplitView {
                List {
                    NavigationLink {
                        MangaListScreen(viewModel: listViewModel)
                    } label: {
                        Label("Mangas", systemImage: "books.vertical")
                    }
                }

            } detail: {
                MangaListScreen(viewModel: listViewModel)
            }
        #endif
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
        .previewDevice("iPad Pro (11-inch)")
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
        .previewDevice("Mac")
}
