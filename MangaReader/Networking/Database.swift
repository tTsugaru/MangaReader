import Foundation
import CloudKit

class Database {
    static let shared = Database()
    private init() {}
    
    let container = CKContainer.default()
    
    
    public func test() async throws {
        let privateDatabase = container.privateCloudDatabase
        
        let record = CKRecord(recordType: "test")
        
        record.setValue("I am a Test", forKey: "testKey")
        
        try await privateDatabase.save(record)
    }
    
}
