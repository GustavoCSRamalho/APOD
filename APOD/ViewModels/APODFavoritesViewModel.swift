import Foundation
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var favorites: [APOD] = []

    private let repository: FavoritesRepositoryProtocol

    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
        fetchFavorites()
    }

    func fetchFavorites() {
        favorites = repository.fetchFavorites()
    }

    func addFavorite(apod: APOD) {
        repository.addFavorite(apod)
        fetchFavorites()
    }

    func removeFavorite(_ apod: APOD) {
        repository.removeFavorite(apod)
        fetchFavorites()
    }

    func isFavorited(apod: APOD) -> Bool {
        repository.isFavorited(apod)
    }
}
