import Foundation
import CloudKit

struct MangaReadState: Encodable {
    let mangaSlug: String
    let chapterHid: String
    let chapterNumber: Int
    let currentChapterImageId: String?
    
    init?(_ record: CKRecord) {
        guard let chapterHid = record["chapterHid"] as? String, let chapterNumber = record["chapterNumber"] as? Int else { return nil }
        self.mangaSlug = record.recordID.recordName
        self.currentChapterImageId = record["currentChapterImageId"] as? String
        self.chapterHid = chapterHid
        self.chapterNumber = chapterNumber
    }
}
