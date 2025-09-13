import Foundation
import Combine

@MainActor
final class APODViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded(APOD)
        case failed(String)
    }

    @Published private(set) var state: State = .idle
    private let service: APODServiceProtocol

    init(service: APODServiceProtocol) {
        self.service = service
    }

    func loadToday() async {
        state = .loading
        let result = await service.fetchAPOD(for: nil)
        
        switch result {
        case .success(let apod):
            state = .loaded(apod)
        case .failure(let error):
            state = .failed(error.userMessage)
        }
    }

    func load(date: String) async {
        state = .loading
        let result = await service.fetchAPOD(for: date)
        
        switch result {
        case .success(let apod):
            state = .loaded(apod)
        case .failure(let error):
            state = .failed(error.userMessage)
        }
    }
}
