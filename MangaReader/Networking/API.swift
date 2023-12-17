import Foundation

enum API: String {
    case trending = "/top"
    case search = "/v1.0/search/"
    case manga = "/comic/"

    private var url: URL {
        let baseURL = "https://api.comick.fun"
        return URL(string: baseURL + rawValue)!
    }

    func request<T: Decodable>(path: String? = nil, param: [String: [String]]? = nil) async throws -> T {
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

        print(Date(), "🌎 - Requesting data from \(editedURL.absoluteString)")

        let (data, _) = try await URLSession.shared.data(from: editedURL)
        let fetchedData = try JSONDecoder().decode(T.self, from: data)

        return fetchedData
    }
}
