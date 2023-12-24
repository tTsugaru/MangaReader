import Foundation

struct MangaReadState: Encodable {
    let chapterHid: String
    let chapterNumber: Int
    let currentChapterImageId: String?
}
