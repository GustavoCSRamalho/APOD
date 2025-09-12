import Foundation
import Combine

@MainActor
final class APODListViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded([APOD])
        case failed(String)
    }

    @Published private(set) var state: State = .idle
    private let service: APODServiceProtocol
    private let lastDays: Int

    init(service: APODServiceProtocol, lastDays: Int = 10) {
        self.service = service
        self.lastDays = lastDays
    }

    func loadLastDays() async {
        state = .loading
        do {
            let today = Date()
            guard let startDate = Calendar.current.date(byAdding: .day, value: -lastDays + 1, to: today) else {
                state = .failed("Could not calculate start date")
                return
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let start = formatter.string(from: startDate)
            let end = formatter.string(from: today)
            let apods = try await service.fetchRange(startDate: start, endDate: end)
            // Ordena do mais recente para o mais antigo
            let sorted = apods.sorted { $0.date > $1.date }
            state = .loaded(sorted)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
