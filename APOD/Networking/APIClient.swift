import Foundation

enum APIError: Error {
    case invalidURL
    case network(Error)
    case invalidResponse
    case decoding(Error)
    case apiError(statusCode: Int)
}

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

final class APIClient {
    private let session: URLSessionProtocol
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func get<T: Decodable>(url: URL, queryItems: [URLQueryItem] = []) async throws -> T {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if !queryItems.isEmpty {
            var existingItems = components?.queryItems ?? []
            existingItems.append(contentsOf: queryItems)
            components?.queryItems = existingItems
        }
        guard let finalURL = components?.url else { throw APIError.invalidURL }
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }
            guard (200...299).contains(http.statusCode) else {
                throw APIError.apiError(statusCode: http.statusCode)
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw APIError.decoding(error)
            }
        } catch {
            throw APIError.network(error)
        }
    }
}
