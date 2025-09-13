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
        let today = Date()
        guard let startDate = Calendar.current.date(byAdding: .day, value: -lastDays + 1, to: today) else {
            state = .failed("Could not calculate start date")
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let start = formatter.string(from: startDate)
        let end = formatter.string(from: today)
        
        let result = await service.fetchRange(startDate: start, endDate: end)
        
        switch result {
        case .success(let apods):
            let sorted = apods.sorted { $0.date > $1.date }
            state = .loaded(sorted)
        case .failure(let error):
            state = .failed(error.userMessage) // ou use sua mensagem amigável
        }
    }
}
