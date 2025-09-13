import Foundation

protocol APODServiceProtocol {
    func fetchAPOD(for date: String?) async -> Result<APOD, APIError>
    func fetchRange(startDate: String, endDate: String) async -> Result<[APOD], APIError>
    func fetchRandom(count: Int) async -> Result<[APOD], APIError>
}

final class APODService: APODServiceProtocol {
    private let client: APIClient
    private let apiKey: String
    private let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!

    init(client: APIClient = APIClient(), apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }

    func fetchAPOD(for date: String? = nil) async -> Result<APOD, APIError> {
        var params: [String: Any] = ["api_key": apiKey]
        if let d = date { params["date"] = d }
        
        do {
            let apod: APOD = try await client.get(url: baseURL, parameters: params)
            return .success(apod)
        } catch let error as APIError {
            return .failure(error)
        } catch {
            return .failure(.network(error))
        }
    }

    func fetchRange(startDate: String, endDate: String) async -> Result<[APOD], APIError> {
        let params: [String: Any] = [
            "api_key": apiKey,
            "start_date": startDate,
            "end_date": endDate
        ]
        
        do {
            let apods: [APOD] = try await client.get(url: baseURL, parameters: params)
            return .success(apods)
        } catch let error as APIError {
            return .failure(error)
        } catch {
            return .failure(.network(error))
        }
    }

    func fetchRandom(count: Int) async -> Result<[APOD], APIError> {
        let params: [String: Any] = [
            "api_key": apiKey,
            "count": count
        ]
        
        do {
            let apods: [APOD] = try await client.get(url: baseURL, parameters: params)
            return .success(apods)
        } catch let error as APIError {
            return .failure(error)
        } catch {
            return .failure(.network(error))
        }
    }
}
