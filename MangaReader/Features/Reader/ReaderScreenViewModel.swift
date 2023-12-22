import Foundation

@MainActor
class ReaderScreenViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var chapterDetailViewModel: ChapterDetailResponse?
    @Published var images: [ChapterImage] = []
    
    func getChapterDetail(chapterId: String) async {
        do {
            isLoading = images.isEmpty
            let chapterDetailResponse = try await Networking.shared.getChapterDetail(hid: chapterId)
            chapterDetailViewModel = chapterDetailResponse
            if self.images.isEmpty {
                self.images = chapterDetailResponse.chapter.images ?? []
            } else {
                self.images += chapterDetailResponse.chapter.images ?? []
            }
            isLoading = images.isEmpty
        } catch {
            print(error)
        }
    }
}
