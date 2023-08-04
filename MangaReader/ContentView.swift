import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        #if os(iOS)
            TabView {
                MangaListScreen()
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
                        MangaListScreen()
                    } label: {
                        Label("Mangas", systemImage: "books.vertical")
                    }
                }
            } detail: {
                Text("Detail Screen Empty")
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
