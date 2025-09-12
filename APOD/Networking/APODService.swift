import Foundation

protocol APODServiceProtocol {
    func fetchAPOD(for date: String?) async throws -> APOD
    func fetchRange(startDate: String, endDate: String) async throws -> [APOD]
    func fetchRandom(count: Int) async throws -> [APOD]
}

final class APODService: APODServiceProtocol {
    private let client: APIClient
    private let apiKey: String
    private let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!

    init(client: APIClient = APIClient(), apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }

    func fetchAPOD(for date: String? = nil) async throws -> APOD {
        var query: [URLQueryItem] = [URLQueryItem(name: "api_key", value: apiKey)]
        if let d = date { query.append(URLQueryItem(name: "date", value: d)) }
        return try await client.get(url: baseURL, queryItems: query)
    }

    func fetchRange(startDate: String, endDate: String) async throws -> [APOD] {
        let query: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "start_date", value: startDate),
            URLQueryItem(name: "end_date", value: endDate)
        ]
        return try await client.get(url: baseURL, queryItems: query)
    }

    func fetchRandom(count: Int) async throws -> [APOD] {
        let query: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "count", value: "\(count)")
        ]
        return try await client.get(url: baseURL, queryItems: query)
    }
}
