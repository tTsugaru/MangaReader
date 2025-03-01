import Foundation
import SwiftData

@Model
public class MangaReadState {
    
    public var mangaSlug: String?
    public var chapterHid: String?
    public var chapterNumber: Int?
    public var currentChapterImageId: String?
    
    public init(mangaSlug: String?, chapterHid: String? = nil, chapterNumber: Int? = nil, currentChapterImageId: String? = nil) {
        self.mangaSlug = mangaSlug
        self.chapterHid = chapterHid
        self.chapterNumber = chapterNumber
        self.currentChapterImageId = currentChapterImageId
    }
}
