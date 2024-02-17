import Foundation
import OSLog
import SwiftData

struct ChapterImageViewModel {
    let model: ChapterImage
    
    var url: URL? {
        if let b2Key = model.b2Key {
            return URL(string: "https://meo.comick.pictures/\(b2Key)")
        } else if let url = model.url {
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
    
    var mangaSlug: String?
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
            
            let chapterImageViewModels = chapterDetailResponse.chapter.images?.compactMap { chapterImage in
                var chapterImageViewModel = ChapterImageViewModel(model: chapterImage)
                chapterImageViewModel.mangaSlug = chapterDetailResponse.chapter.mdComics.slug
                return chapterImageViewModel
            }
            
            if let chapterImageViewModels {
                if images.isEmpty {
                    images = chapterImageViewModels
                } else {
                    images += chapterImageViewModels
                }
            }
            
            isLoading = images.isEmpty
        } catch {
            print(error)
        }
    }
    
    func editMangaReadState(currentMangaReadState: MangaReadState, chapterImageId: String) -> MangaReadState {
        if let chapterNumber = Int(chapterDetailViewModel?.chapter.chap ?? ""), chapterNumber >= (currentMangaReadState.chapterNumber ?? 0) {
            currentMangaReadState.chapterNumber = chapterNumber
            currentMangaReadState.chapterHid = chapterDetailViewModel?.chapter.hid
        }
        return currentMangaReadState
    }
}

extension ReaderScreenViewModel {
    var logger: Logger {
        return Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ReaderScreenViewModel")
    }
}
