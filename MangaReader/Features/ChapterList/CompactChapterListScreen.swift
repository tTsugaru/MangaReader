import SwiftUI

struct CompactChapterListScreen: View {
    @Binding var path: NavigationPath
    var mangaSlug: String
    var chapterListItems: [ChapterListItem]

    @StateObject var mangaStore = MangaStore.shared

    @State private var isCollapsingChildren: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    VStack(spacing: 0) {
                        ForEach(Array(chapterListItems.enumerated()), id: \.element.id) { index, chapterItem in
                            ChapterItemView(
                                chapterItem: chapterItem,
                                isFirst: index == 0,
                                isLast: index == chapterListItems.endIndex - 1
                            ) { chapterListItem in
                                path.append(ChapterNavigation(chapterId: chapterListItem.id, currentChapterImageId: nil))
                            }
                        }
                        Spacer()
                    }
                }
                .padding(16)
                .frame(minHeight: geometry.size.height)
                .animation(.easeInOut(duration: 0.25))
            }
            .frame(width: geometry.size.width)
            .background {
                if let colors = mangaStore.prominentColors[mangaSlug] {
                    FloatingCloudsView(colors: colors)
                        .ignoresSafeArea()
                }
            }
            .background {
                if let color = mangaStore.averageCoverColors[mangaSlug] {
                    color
                        .opacity(0.5)
                        .ignoresSafeArea()
                }
            }
            .navigationBarBackButtonHidden()
            #if !os(macOS)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        CustomBackButton()
                    }
                }
            #endif
                .foregroundStyle(mangaStore.averageCoverColors[mangaSlug]?.isLightColor ?? false ? .black : .white)
        }
    }
}
