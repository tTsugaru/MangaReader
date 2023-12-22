import Foundation
import CloudKit

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
    
    public func saveReadState(for mangaSlug: String, at chapterHid: String, chapterNumber: Int) async throws {
        let privateDatabase = container.privateCloudDatabase
        let fetchedRecord = try? await privateDatabase.record(for: .init(recordName: mangaSlug))
        
        if let fetchedRecord, let fetchedChapterNumber = fetchedRecord.value(forKey: "chapterNumber") as? Int {
            guard fetchedChapterNumber < chapterNumber else { return }
            
            let newValues: [String: Any] = [
                "chapterHid": chapterHid,
                "chapterNumber": chapterNumber
            ]
            
            fetchedRecord.setValuesForKeys(newValues)
            _ = try await privateDatabase.modifyRecords(saving: [fetchedRecord], deleting: [])
        } else {
            let newRecord = CKRecord(recordType: "MangaReadState", recordID: .init(recordName: mangaSlug))
            let values: [String: Any] = [
                "chapterHid": chapterHid,
                "chapterNumber": chapterNumber
            ]
            
            newRecord.setValuesForKeys(values)
            _ = try await privateDatabase.save(newRecord)
        }
    }
}
