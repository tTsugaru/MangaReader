import Detail
import History
import MangaList
import Models
import Styles
import SwiftData
import SwiftUI

public struct ContentView: View {

    @EnvironmentObject private var theme: Theme

    @State private var selectedTabIndex: Int = 0

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTabIndex) {
            Tab(value: 0) {
                NavigationStack {
                    MangaListScreen()
                        .navigationDestination(for: MangaViewModel.self) { mangaViewModel in
                            MangaDetailScreen(mangaSlug: mangaViewModel.slug)
                        }
                }
            } label: {
                VStack {
                    Text("Mangas")
                    Image(systemName: "list.bullet")
                }
            }

            Tab(value: 1) {
                NavigationStack {
                    Text("Under construction...")
                }
            } label: {
                VStack {
                    Text("Favorites")
                    Image(systemName: "star.fill")
                }
            }

            Tab(value: 2) {
                NavigationStack {
                    HistoryScreen()
                }
            } label: {
                VStack {
                    Text("History")
                    Image(systemName: "clock")
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tint(theme.toolbarTint)
    }

    private func handleDestinations() {}
}

#Preview() {
    ContentView()
        .environmentObject(Theme())
}
