import Foundation
import Combine

@MainActor
class MangaDetailScreenViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var mangaDetail: MangaDetail?
    
    @Published var chapterItems: [ChapterListItem] = [
        ChapterListItem(title: "Publisher 1", children: [
            ChapterListItem(title: "Chapter 1"),
            ChapterListItem(title: "Chapter 2"),
            ChapterListItem(title: "Chapter 3")
        ]),
        ChapterListItem(title: "Publisher 2", children: [
            ChapterListItem(title: "Chapter 4"),
            ChapterListItem(title: "Chapter 5"),
            ChapterListItem(title: "Chapter 6")
        ]),
        ChapterListItem(title: "Publisher 3", children: [
            ChapterListItem(title: "Chapter 7"),
            ChapterListItem(title: "Chapter 8"),
            ChapterListItem(title: "Chapter 9")
        ]),
    ]
    
    func getMangaDetail(slug: String) async {
        do {
            isLoading = true
            let mangaDetail = try await Networking.shared.getMangaDetails(slug: slug)
            self.mangaDetail = mangaDetail
            isLoading = false
        } catch {
            print(error)
        }
    }
}
