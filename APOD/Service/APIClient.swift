import Foundation
import Alamofire

enum APIError: Error {
    case network(Error)
    case apiError(statusCode: Int)
    case decoding(Error)
}

final class APIClient {
    func get<T: Decodable>(url: URL, parameters: [String: Any] = [:]) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
                .validate(statusCode: 200...299)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let decoded = try JSONDecoder().decode(T.self, from: data)
                            continuation.resume(returning: decoded)
                        } catch {
                            continuation.resume(throwing: APIError.decoding(error))
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode {
                            continuation.resume(throwing: APIError.apiError(statusCode: statusCode))
                        } else {
                            continuation.resume(throwing: APIError.network(error))
                        }
                    }
                }
        }
    }
}
