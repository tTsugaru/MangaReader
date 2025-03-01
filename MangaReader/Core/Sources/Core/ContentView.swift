import ChapterList
import Detail
import History
import MangaList
import Models
import Styles
import SwiftData
import SwiftUI

public struct ContentView: View {
    @EnvironmentObject private var theme: Theme

    @State private var selectedTabIndex = 0

    public init() {
        // no-op
    }

    public var body: some View {
        TabView {
            Tab {
                NavigationStack {
                    MangaListScreen()
                        .navigationDestination(for: MangaViewModel.self) { mangaViewModel in
                            MangaDetailScreen(mangaSlug: mangaViewModel.slug)
                        }
                    #if os(iOS)
                        .navigationDestination(for: [ChapterListItem].self) { chapterListItems in
                            CompactChapterListScreen(chapterListItems: chapterListItems)
                        }
                    #endif
                }
                .tint(theme.toolbarTint)
            } label: {
                VStack {
                    Text("Mangas")
                    Image(systemName: "list.bullet")
                        .accessibilityLabel("Manga List Tab Icon")
                }
            }

            Tab {
                NavigationStack {
                    Text("Under construction...")
                }
                .tint(theme.toolbarTint)
            } label: {
                VStack {
                    Text("Favorites")
                    Image(systemName: "star.fill")
                        .accessibilityLabel("Favorites Tab Icon")
                }
            }

            Tab {
                NavigationStack {
                    HistoryScreen()
                }
                .tint(theme.toolbarTint)
            } label: {
                VStack {
                    Text("History")
                    Image(systemName: "clock")
                        .accessibilityLabel("History Tab Icon")
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tint(theme.tabBarTint)
    }
}
