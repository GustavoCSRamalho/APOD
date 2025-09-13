import Foundation
@testable import APOD

enum MockError: Error, LocalizedError {
    case testFailure
    
    var errorDescription: String? {
        switch self {
        case .testFailure:
            return "Mock failure"
        }
    }
}

final class MockAPODService: APODServiceProtocol {
    var shouldFail = false
    var mockAPODs: [APOD] = [
        APOD(date: "2025-09-12", explanation: "Test 1", hdurl: nil, media_type: "image", service_version: "v1", title: "Title 1", url: "https://example.com/1.jpg"),
        APOD(date: "2025-09-11", explanation: "Test 2", hdurl: nil, media_type: "image", service_version: "v1", title: "Title 2", url: "https://example.com/2.jpg")
    ]
    
    func fetchAPOD(for date: String?) async -> Result<APOD, APIError> {
        if shouldFail {
            return .failure(.network(MockError.testFailure))
        }
        if let date = date, let apod = mockAPODs.first(where: { $0.date == date }) {
            return .success(apod)
        } else {
            return .success(mockAPODs.first!)
        }
    }
    
    func fetchRange(startDate: String, endDate: String) async -> Result<[APOD], APIError> {
        if shouldFail {
            return .failure(.network(MockError.testFailure))
        }
        let filtered = mockAPODs.filter { $0.date >= startDate && $0.date <= endDate }
        return .success(filtered)
    }
    
    func fetchRandom(count: Int) async -> Result<[APOD], APIError> {
        if shouldFail {
            return .failure(.network(MockError.testFailure))
        }
        return .success(Array(mockAPODs.prefix(count)))
    }
}
