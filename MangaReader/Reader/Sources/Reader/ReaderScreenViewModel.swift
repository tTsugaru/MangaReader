import Foundation
import Models
import Networking
import OSLog
import SwiftData

@MainActor
public class ReaderScreenViewModel: ObservableObject {
    @Published public var readerTitle = ""
    @Published public var isLoading = false
    @Published public var chapterDetailViewModel: ChapterDetailResponse?
    @Published public var images: [ChapterImageViewModel] = []

    public init() {
        // no-op
    }

    public func getChapterDetail(chapterId: String) async {
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

    public func editMangaReadState(currentMangaReadState: MangaReadState) -> MangaReadState {
        if let chapterNumber = Int(chapterDetailViewModel?.chapter.chap ?? ""), chapterNumber >= (currentMangaReadState.chapterNumber ?? 0) {
            currentMangaReadState.chapterNumber = chapterNumber
            currentMangaReadState.chapterHid = chapterDetailViewModel?.chapter.hid
        }
        return currentMangaReadState
    }
}

extension ReaderScreenViewModel {
    private var logger: Logger {
        return Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ReaderScreenViewModel")
    }
}
