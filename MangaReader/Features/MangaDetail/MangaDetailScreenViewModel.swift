import Combine
import Foundation

@MainActor
class MangaDetailScreenViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var mangaDetail: MangaDetail?

    @Published var chapters = [Chapter]()
    @Published var chapterItems: [ChapterListItem] = []

    func fetchData(mangaSlug: String) async {
        isLoading = true
        await getMangaDetail(slug: mangaSlug)

        if let mangaHid = mangaDetail?.comic.hid, chapters.isEmpty {
            await getChapters(hid: mangaHid)
        } else {
            isLoading = false
        }
    }

    private func getMangaDetail(slug: String) async {
        URLCache.shared.removeAllCachedResponses()
        do {
            let mangaDetail = try await Networking.shared.getMangaDetails(slug: slug)
            self.mangaDetail = mangaDetail
        } catch {
            print(error)
        }
    }

    private func getChapters(hid: String) async {
        do {
            let chapterResponse = try await Networking.shared.getChapters(hid: hid, limit: 1)
            guard chapterResponse.total > 0 else { return }

            let allChapterResponse = try await Networking.shared.getChapters(hid: hid, limit: chapterResponse.total)
            chapters = allChapterResponse.chapters

            let groupNames = Array(Set(chapters.compactMap { $0.groupName?.first }))
            let chapterListItems = groupNames.map { ChapterListItem(id: UUID().uuidString, title: $0) }

            Task.detached(priority: .background) {
                Task { @MainActor in
                    self.chapterItems = chapterListItems.map { chapterListItem in
                        let chapters = self.chapters
                            .filter { $0.groupName?.first ?? "" == chapterListItem.title }
                            .map { ChapterListItem(id: $0.hid, title: $0.title ?? $0.chap ?? $0.vol ?? "Unkown Chapter") }

                        chapterListItem.children = chapters
                        return chapterListItem
                    }

                    self.isLoading = false
                }
            }
        } catch {
            print(error)
        }
    }
}
