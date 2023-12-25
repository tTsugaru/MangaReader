import Foundation
import CloudKit

struct MangaReadState: Encodable {
    let chapterHid: String
    let chapterNumber: Int
    let currentChapterImageId: String?
    
    init?(_ record: CKRecord) {
        guard let chapterHid = record[""] as? String, let chapterNumber = record[""] as? Int else { return nil }
        self.currentChapterImageId = record["currentChapterImageId"] as? String
        self.chapterHid = chapterHid
        self.chapterNumber = chapterNumber
    }
}
