import Foundation
import SwiftData

@Model
class MangaReadState {
    @Attribute(.unique) var mangaSlug: String
    var chapterHid: String?
    var chapterNumber: Int?
    var currentChapterImageId: String?
    
    init(mangaSlug: String, chapterHid: String? = nil, chapterNumber: Int? = nil, currentChapterImageId: String? = nil) {
        self.mangaSlug = mangaSlug
        self.chapterHid = chapterHid
        self.chapterNumber = chapterNumber
        self.currentChapterImageId = currentChapterImageId
    }
}
