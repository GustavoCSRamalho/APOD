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
        var params: [String: Any] = ["api_key": apiKey]
        if let d = date { params["date"] = d }
        return try await client.get(url: baseURL, parameters: params)
    }

    func fetchRange(startDate: String, endDate: String) async throws -> [APOD] {
        let params: [String: Any] = [
            "api_key": apiKey,
            "start_date": startDate,
            "end_date": endDate
        ]
        return try await client.get(url: baseURL, parameters: params)
    }

    func fetchRandom(count: Int) async throws -> [APOD] {
        let params: [String: Any] = [
            "api_key": apiKey,
            "count": count
        ]
        return try await client.get(url: baseURL, parameters: params)
    }
}
