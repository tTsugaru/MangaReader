import Models
import Styles
import SwiftUI

@available(iOS, message: "Only available on iOS")
public struct CompactChapterListScreen: View {
    
    @Binding private var path: NavigationPath
    private var mangaSlug: String
    private var chapterListItems: [ChapterListItem]

    @State private var chapterItemViewChanged: Bool = false
    
    public init(path: Binding<NavigationPath>, mangaSlug: String, chapterListItems: [ChapterListItem]) {
        self._path = path
        self.mangaSlug = mangaSlug
        self.chapterListItems = chapterListItems
    }

    #warning("fix expanding")
    public var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    VStack(spacing: 0) {
                        ForEach(Array(chapterListItems.enumerated()), id: \.element.id) { index, chapterItem in
                            ChapterItemView(
                                chapterItem: chapterItem,
                                expand: false,
                                expandingChanged: $chapterItemViewChanged,
                                isFirst: index == 0,
                                isLast: index == chapterListItems.endIndex - 1
                            ) { chapterListItem in
                                guard let chapterListItem else { return }
                                path.append(ChapterNavigation(chapterId: chapterListItem.id, currentChapterImageId: nil))
                            }
                        }
                        Spacer()
                    }
                }
                .padding(16)
                .frame(minHeight: geometry.size.height)
                .animation(.easeInOut(duration: 0.25), value: chapterItemViewChanged)
            }
            .frame(width: geometry.size.width)
            .background {
//                if let colors = mangaStore.prominentColors[mangaSlug] {
//                    FloatingCloudsView(colors: colors)
//                        .ignoresSafeArea()
//                }
            }
            .background {
//                if let color = mangaStore.averageCoverColors[mangaSlug] {
//                    color
//                        .opacity(0.5)
//                        .ignoresSafeArea()
//                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CustomBackButton()
                }
            }
//            .foregroundStyle(mangaStore.averageCoverColors[mangaSlug]?.isLightColor ?? false ? .black : .white)
        }
    }
}
