import Foundation
import SwiftUI

@MainActor
final class MockFavoritesRepository: FavoritesRepositoryProtocol {
    // Mantém os favoritos em memória
    private var favoritesStorage: [APOD]

    init() {
        // Dados de exemplo
        let sampleAPOD1 = APOD(
            date: "2025-09-13",
            explanation: "Sample explanation 1",
            hdurl: nil,
            media_type: "image",
            service_version: "v1",
            title: "Sample Title 1",
            url: "https://example.com/image1.jpg"
        )
        let sampleAPOD2 = APOD(
            date: "2025-09-12",
            explanation: "Sample explanation 2",
            hdurl: nil,
            media_type: "image",
            service_version: "v1",
            title: "Sample Title 2",
            url: "https://example.com/image2.jpg"
        )
        favoritesStorage = [sampleAPOD1, sampleAPOD2]
    }

    func fetchFavorites() -> [APOD] {
        return favoritesStorage
    }

    func addFavorite(_ apod: APOD) {
        if !favoritesStorage.contains(where: { $0.date == apod.date }) {
            favoritesStorage.append(apod)
        }
    }

    func removeFavorite(_ apod: APOD) {
        favoritesStorage.removeAll { $0.date == apod.date }
    }

    func isFavorited(_ apod: APOD) -> Bool {
        favoritesStorage.contains { $0.date == apod.date }
    }
}
