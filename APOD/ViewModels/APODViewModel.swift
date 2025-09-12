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
        do {
            let apod = try await service.fetchAPOD(for: nil)
            state = .loaded(apod)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    func load(date: String) async {
        state = .loading
        do {
            let apod = try await service.fetchAPOD(for: date)
            state = .loaded(apod)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
