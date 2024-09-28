import Combine
import Foundation
import OrderedCollections
import SwiftData

@MainActor
class MangaDetailScreenViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var mangaDetail: MangaDetailViewModel?

    @Published var chapters = [Chapter]()
    @Published var chapterItems: [ChapterListItem] = []
    @Published var mangaReadState: MangaReadState? = nil
    @Published var expandedChapterList: [String: Bool] = [:]

    func fetchData(mangaSlug: String) async {
        self.isLoading = true
        await self.getMangaDetail(slug: mangaSlug)

        if let mangaHid = mangaDetail?.hid, let mangaSlug = mangaDetail?.slug, chapters.isEmpty {
            await self.getChapters(hid: mangaHid, mangaSlug: mangaSlug)
        } else {
            self.isLoading = false
        }
    }
    
    func handleExpanding(for groupId: String) {
        expandedChapterList[groupId, default: false].toggle()
    }

    private func getMangaDetail(slug: String) async {
        do {
            let mangaDetail = try await Networking.shared.getMangaDetails(slug: slug)
            self.mangaDetail = MangaDetailViewModel(mangaDetail)
        } catch {
            print(error)
        }
    }

    private func getChapters(hid: String, mangaSlug: String) async {
        Task.detached(priority: .background) {
            do {
                let chapterResponse = try await Networking.shared.getChapters(hid: hid, limit: 1)
                guard chapterResponse.total > 0 else { return }
                
                let allChapterResponse = try await Networking.shared.getChapters(hid: hid, limit: chapterResponse.total)
                // TODO: Remove this 
                let chapters = allChapterResponse.chapters.filter { $0.lang == "en" }
                
                let groupNames = Array(Set(chapters.compactMap { $0.groupName?.first }))
                
                let chapterListItems = groupNames.map { groupName in
                    let groupId = UUID().uuidString
                    let children = chapters
                        .filter { groupName == $0.groupName?.first ?? "" }
                        .map { chapter in
                            ChapterListItem(id: chapter.hid, title: chapter.title ?? chapter.chap ?? chapter.vol ?? "Unknown Chapter", parentId: groupId, mangaSlug: mangaSlug)
                        }
                    return ChapterListItem(id: groupId, title: groupName, mangaSlug: mangaSlug, children: children)
                }
                
                Task { @MainActor in
                    self.objectWillChange.send()
                    self.chapters = chapters
                    self.chapterItems = chapterListItems
                    self.isLoading = false
                }
            } catch {
                print(error)
            }
        }
    }
}
