import Foundation

enum API: String {
    case trending = "/top"
    case search = "/v1.0/search/?page=1&limit=1&tachiyomi=true&t=false"
    
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
}

class Networking {
    
    public static let shared = Networking()
    private init() {}
    
    func getAllMangas() async throws -> [Manga] {
        return try await API.search.request()
    }
}
