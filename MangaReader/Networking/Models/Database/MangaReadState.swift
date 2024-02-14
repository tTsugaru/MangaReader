import Foundation
import CloudKit

struct MangaReadState: Codable {
    var mangaSlug: String
    var chapterHid: String
    var chapterNumber: Int
    var currentChapterImageId: String?
    
//    init?(_ record: CKRecord) {
//        guard let chapterHid = record["chapterHid"] as? String, let chapterNumber = record["chapterNumber"] as? Int else { return nil }
//        self.mangaSlug = record.recordID.recordName
//        self.currentChapterImageId = record["currentChapterImageId"] as? String
//        self.chapterHid = chapterHid
//        self.chapterNumber = chapterNumber
//    }
}
