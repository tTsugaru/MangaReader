import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

enum API: String {
    case trending = "/top"
    case search = "/v1.0/search/?page=1&limit=50&tachiyomi=true&t=false"
    
    private var url: URL {
        let baseURL = "https://api.comick.fun"
        return URL(string: baseURL + self.rawValue)!
    }
    
    // Make support for advanced requests like with params
    func request<T: Decodable>() async throws -> [T] {
        let (data, _) = try await URLSession.shared.data(from: self.url)
        let fetchedData = try JSONDecoder().decode([T].self, from: data)
        
        return fetchedData
    }
    
    static func loadImage(with id: String) async throws -> Image {
        let imageURL = URL(string: "https://meo.comick.pictures/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: imageURL)
        
        #if os(iOS)
        let fetchedImage = UIImage(data: data)
        guard let fetchedImage else { return Image(systemName: "exclamationmark.triangle.fill") }
        return Image(uiImage: fetchedImage)
        #elseif os(macOS)
        let fetchedImage = NSImage(data: data)
        guard let fetchedImage else { return Image(systemName: "exclamationmark.triangle.fill") }
        return Image(nsImage: fetchedImage)
        #endif
        
    }
}

class Networking {
    
    public static let shared = Networking()
    private init() {}
    
    func getAllMangas() async throws -> [Manga] {
        return try await API.search.request()
    }
}
