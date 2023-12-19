import SwiftUI

struct CompactChapterListScreen: View {
    @Binding var isLoading: Bool
    @ObservedObject var mangaViewModel: MangaViewModel
    @Binding var chapterListItems: [ChapterListItem]
    @State private var isCollapsingChildren: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    } else {
                        VStack(spacing: 0) {
                            ForEach(Array(chapterListItems.enumerated()), id: \.element.id) { index, chapterItem in
                                ChapterItemView(
                                    chapterItem: chapterItem,
                                    isFirst: index == 0,
                                    isLast: index == chapterListItems.endIndex - 1
                                ) { _ in
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .padding(16)
                .frame(minHeight: geometry.size.height)
                .animation(.easeInOut(duration: 0.25))
            }
            .frame(width: geometry.size.width)
            .background {
                FloatingCloudsView(colors: mangaViewModel.prominentColors)
                    .ignoresSafeArea()
            }
            .background {
                mangaViewModel.avrageCoverColor?.opacity(0.5)
                    .ignoresSafeArea()
            }
            .navigationBarBackButtonHidden()
            #if !os(macOS)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        CustomBackButton()
                    }
                }
            #endif
                .foregroundStyle(mangaViewModel.isLightCoverColor ? .black : .white)
        }
    }
}
