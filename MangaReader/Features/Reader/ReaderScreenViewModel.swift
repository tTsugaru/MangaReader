import Foundation

struct ChapterImageViewModel {
    let model: ChapterImage
    
    var url: URL? {
        if let b2Key = model.b2Key {
            return URL(string: "https://meo.comick.pictures/\(b2Key)")
        } else if let url = model.url{
            return URL(string: url)
        } else {
            return nil
        }
    }
    
    var width: Int {
        return model.w
    }
    
    var height: Int {
        return model.h
    }
}
@MainActor
class ReaderScreenViewModel: ObservableObject {
    @Published var readerTitle: String = ""
    @Published var isLoading: Bool = false
    @Published var chapterDetailViewModel: ChapterDetailResponse?
    @Published var images: [ChapterImageViewModel] = []

    func getChapterDetail(chapterId: String) async {
        do {
            isLoading = images.isEmpty
            let chapterDetailResponse = try await Networking.shared.getChapterDetail(hid: chapterId)

            readerTitle = chapterDetailResponse.chapTitle ?? chapterDetailResponse.chapter.chap
            chapterDetailViewModel = chapterDetailResponse
            
            let chapterImageViewModels = chapterDetailResponse.chapter.images?.compactMap { ChapterImageViewModel(model: $0) }
            
            if let chapterImageViewModels {
                if  images.isEmpty {
                    images = chapterImageViewModels
                } else {
                    images += chapterImageViewModels
                }
            }
            
            if let firstChapterImageId = images.first?.url {
                await saveCurrentChapterLocation(chapterImageId: firstChapterImageId.absoluteString)
            }

            isLoading = images.isEmpty
        } catch {
            print(error)
        }
    }

    #warning("refactor")
    func saveCurrentChapterLocation(chapterImageId: String) async {
        do {
            if let chapterNumber = Int(chapterDetailViewModel?.chapter.chap ?? ""), let mangaSlug = chapterDetailViewModel?.chapter.mdComics.slug, let chapterId = chapterDetailViewModel?.chapter.hid {
                try await Database.shared.saveReadState(for: mangaSlug, at: chapterId, chapterNumber: chapterNumber, currentChapterImageId: chapterImageId)
            }
        } catch {
            print(error)
        }
    }
}
