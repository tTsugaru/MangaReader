import Foundation

enum API: String {
    case trending = "/top"
    case search = "/v1.0/search/"
    case manga = "/comic/"

    private var url: URL {
        let baseURL = "https://api.comick.fun"
        return URL(string: baseURL + rawValue)!
    }

    func request<T: Decodable>(path: String? = nil, param: [String: [String]]? = nil, cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad) async throws -> T {
        var editedURL = url

        if let path {
            editedURL = url.appendingPathComponent(path)
        }

        if let param, var components = URLComponents(url: editedURL, resolvingAgainstBaseURL: true) {
            components.queryItems = param.map { URLQueryItem(name: $0.key, value: $0.value.joined(separator: ",")) }
            if let urlWithParams = components.url {
                editedURL = urlWithParams
            }
        }

        let urlRequest = URLRequest(url: editedURL, cachePolicy: cachePolicy)
        let cachedURLResponse = URLCache.shared.cachedResponse(for: urlRequest)
        
        if let cachedURLResponse {
            let httpRespnse = cachedURLResponse.response as? HTTPURLResponse
            print(Date(), "💾 - Requesting data for \(editedURL.absoluteString) |", httpRespnse?.allHeaderFields["Cache-Control"] ?? "No Info")
            let data = cachedURLResponse.data
            let cachedData = try JSONDecoder().decode(T.self, from: data)
            return cachedData
        } else {
            print(Date(), "🌎 - Requesting data from \(editedURL.absoluteString)")
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let fetchedData = try JSONDecoder().decode(T.self, from: data)
            return fetchedData
        }
    }
}
