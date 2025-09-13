import Foundation
@testable import APOD

@MainActor
final class MockFavoritesRepository: FavoritesRepositoryProtocol {

    private var storedFavorites: [APOD] = []

    func fetchFavorites() -> [APOD] {
        storedFavorites
    }

    func addFavorite(_ apod: APOD) {
        if !storedFavorites.contains(where: { $0.date == apod.date }) {
            storedFavorites.append(apod)
        }
    }

    func removeFavorite(_ apod: APOD) {
        storedFavorites.removeAll { $0.date == apod.date }
    }

    func isFavorited(_ apod: APOD) -> Bool {
        storedFavorites.contains { $0.date == apod.date }
    }
}
