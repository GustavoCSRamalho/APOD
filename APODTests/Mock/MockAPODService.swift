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
    
    func fetchRange(startDate: String, endDate: String) async throws -> [APOD] {
        if shouldFail { throw MockError.testFailure }
        return mockAPODs
    }
    
    func fetchAPOD(for date: String?) async throws -> APOD {
        if shouldFail { throw MockError.testFailure }
        if let date = date, let apod = mockAPODs.first(where: { $0.date == date }) {
            return apod
        } else {
            return mockAPODs.first!
        }
    }
    
    func fetchRandom(count: Int) async throws -> [APOD] {
        if shouldFail { throw MockError.testFailure }
        return Array(mockAPODs.prefix(count))
    }
}
