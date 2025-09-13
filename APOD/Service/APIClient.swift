import Foundation
import Alamofire

enum APIError: Error {
    case network(Error)
    case apiError(statusCode: Int)
    case decoding(Error)
    
    var userMessage: String {
           switch self {
           case .network(_):
               return "Não foi possível conectar. Verifique sua internet e tente novamente."
           case .apiError(_):
               return "Ocorreu um erro ao carregar os dados. Tente novamente mais tarde."
           case .decoding(_):
               return "Ocorreu um problema ao processar os dados recebidos."
           }
       }
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
