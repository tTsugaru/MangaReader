import Foundation
import SwiftUI
#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

enum API: String {
    case trending = "/top"
    case search = "/v1.0/search/?page=1&limit=8&tachiyomi=true&t=false"

    private var url: URL {
        let baseURL = "https://api.comick.fun"
        return URL(string: baseURL + rawValue)!
    }

    func request<T: Decodable>(param: [String: [String]]? = nil) async throws -> [T] {
        var editedURL = url
        
        if let param, var components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            components.queryItems = param.map { URLQueryItem(name: $0.key, value: $0.value.joined(separator: ",")) }
            if let urlWithParams = components.url {
                editedURL = urlWithParams
            }
        }
        
        let (data, _) = try await URLSession.shared.data(from: editedURL)
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
        try await API.search.request()
    }
    
    enum SearchType: String {
        case author
        case user
        case group
        case comic
        case none = ""
    }
    
    enum SearchSortType: String {
        case follow
        case view
        case createdAt = "created_at"
        case uploaded
        case rating
        case userFollowCount = "user_follow_count"
    }
    
    func search(with genres: [String] = [],
                excludes: [String] = [],
                type: SearchType = .none,
                tags: [String] = [],
                demographic: [Int] = [],
                page: Int = 1,
                limit: Int = 30,
                time: Int? = nil,
                country: [String] = [],
                minChapterCount: Int? = nil,
                fromYear: Int? = nil,
                toYear: Int? = nil,
                status: MangaStatus? = nil,
                tachiyomi: Bool = true,
                completed: Bool? = nil,
                sort: SearchSortType?,
                excludeMyList: Bool? = nil,
                searchString: String = "",
                showAltTitle: Bool? = nil) async throws -> [Manga] {
        
        var params: [String: [String]] = [:]
        
        if searchString.isEmpty {
            params["genres"] = genres
            params["excludes"] = excludes
            params["tags"] = tags
            params["demograpic"] = demographic.map { String($0) }
            params["page"] = [String(page)]
            params["limit"] = [String(limit)]
            params["country"] = country
            
            if let time {
                params["time"] = [String(time)]
            }
            
            if let minChapterCount {
                params["minimum"] = [String(minChapterCount)]
            }
            
            if let fromYear {
                params["from"] = [String(fromYear)]
            }
            
            
            if let toYear {
                params["to"] = [String(toYear)]
            }
            
            if let status {
                params["from"] = [String(status.rawValue)]
            }
            
            if let completed {
                params["completed"] = [String(completed)]
            }
            
            if let sort {
                params["sort"] = [sort.rawValue]
            }
            
            if let excludeMyList {
                params["exclude-mylist"] = [String(excludeMyList)]
            }
            
            if let showAltTitle {
                params("t") = [String(showAltTitle)]
            }
            
        } else {
            params["q"] = [searchString]
            return try await API.search.request(param: params)
        }
        return return try await API.search.request(param: params)
    }
}
