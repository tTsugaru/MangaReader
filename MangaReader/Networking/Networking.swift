import Foundation
import SwiftUI

class Networking {
    public static let shared = Networking()
    private init() {}

    // TODO: Try to simplify
    func search(with genres: [String] = [],
                excludes: [String] = [],
                type _: SearchType = .none,
                tags: [String] = [],
                demographic: [Int] = [],
                page: Int = 1,
                limit: Int = 50,
                time: Int? = nil,
                country: [String]? = nil,
                minChapterCount: Int? = nil,
                fromYear: Int? = nil,
                toYear: Int? = nil,
                status: MangaStatus? = nil,
                tachiyomi _: Bool = true,
                completed: Bool? = nil,
                sort: SearchSortType? = nil,
                excludeMyList: Bool? = nil,
                searchString: String = "",
                showAltTitle: Bool? = nil) async throws -> [Manga]
    {
        var params: [String: [String]] = [:]

        if searchString.isEmpty {
            params["genres"] = genres
            params["excludes"] = excludes
            params["tags"] = tags
            params["demograpic"] = demographic.map { String($0) }
            params["page"] = [String(page)]
            params["limit"] = [String(limit)]

            if let country {
                params["country"] = country
            }

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
                params["t"] = [String(showAltTitle)]
            }
        } else {
            params["q"] = [searchString]
            return try await API.search.request(param: params)
        }

        return try await API.search.request(param: params)
    }
    
    func getMangaDetails(slug: String) async throws -> MangaDetail {
        var params = [String: [String]]()
        
        params["tachiyomi"] = ["true"]
        
        return try await API.manga.request(path: slug, param: params, cachePolicy: .returnCacheDataElseLoad)
    }
    
    func getChapters(hid: String, limit: Int = 300) async throws -> ChapterResponse {
        var params = [String: [String]]()
        params["limit"] = [String(limit)]
        
        return try await API.mangaChapters(hid: hid).request(param: params)
    }
    
    func getChapterDetail(hid: String) async throws -> ChapterDetailResponse {
        return try await API.chapter(hid: hid).request(param: ["tachiyomi": ["true"]])
    }
}
