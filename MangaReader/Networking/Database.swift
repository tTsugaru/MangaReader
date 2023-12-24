import CloudKit
import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

class Database {
    static let shared = Database()
    private init() {}

    let container = CKContainer.default()

    public func saveReadState(for mangaSlug: String, at chapterHid: String, chapterNumber: Int, currentChapterImageId: String? = nil) async throws {
        let privateDatabase = container.privateCloudDatabase
        let fetchedRecord = try? await privateDatabase.record(for: .init(recordName: mangaSlug))

        if let fetchedRecord, let fetchedChapterNumber = fetchedRecord.value(forKey: "chapterNumber") as? Int {
            guard fetchedChapterNumber <= chapterNumber else { return }

            var newValues: [String: Any] = [
                "chapterHid": chapterHid,
                "chapterNumber": chapterNumber
            ]

            if let currentChapterImageId {
                newValues["currentChapterImageId"] = currentChapterImageId
            }

            fetchedRecord.setValuesForKeys(newValues)
            _ = try await privateDatabase.modifyRecords(saving: [fetchedRecord], deleting: [])
        } else {
            let newRecord = CKRecord(recordType: "MangaReadState", recordID: .init(recordName: mangaSlug))
            var values: [String: Any] = [
                "chapterHid": chapterHid,
                "chapterNumber": chapterNumber
            ]

            if let currentChapterImageId {
                values["currentChapterImageId"] = currentChapterImageId
            }

            newRecord.setValuesForKeys(values)
            _ = try await privateDatabase.save(newRecord)
        }
    }

    // TODO: Add multiple MangaReadState support for different languages
    func getMangaReadState(for mangaSlug: String) async throws -> MangaReadState? {
        let privateDatabase = container.privateCloudDatabase
        let fetchedRecord = try? await privateDatabase.record(for: .init(recordName: mangaSlug))

        // TODO: Investigage for a simpler solution like "CKRecord as? <OBJECT>" and otherway to "<OBJECT> as? CKRecord"
        guard let fetchedRecord,
           let chapterHid = fetchedRecord["chapterHid"] as? String,
           let chapterNumber = fetchedRecord["chapterNumber"] as? Int
        else { return nil }
        
        let currentChapterImageId = fetchedRecord["currentChapterImageId"] as? String
        return MangaReadState(chapterHid: chapterHid, chapterNumber: chapterNumber, currentChapterImageId: currentChapterImageId)
    }
}
