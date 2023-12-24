import Foundation
import SwiftUI

class MangaStore: ObservableObject {
    static let shared = MangaStore()
    private init() {}

    @Published var prominentColors = [String: [Color]]()
    @Published var averageCoverColors = [String: Color]()
    
    func storeColors() {
        // TODO: Implement storing colors on disk or private Database
        print("STORE MEEEE!")
    }
    
    func loadStoredColors() {
        // TODO: Implement loading colors from disk or private Database
    }
}
