import Foundation
import SwiftUI

@MainActor
final class MockFavoritesRepository: FavoritesRepositoryProtocol {
    private var favoritesStorage: [APOD]

    init() {
        let sampleAPOD1 = APOD(
            date: "2025-09-03",
            explanation: "How soon do jets form when a supernova gives birth to a neutron star?  The Africa Nebula provides clues. ...",
            hdurl: "https://apod.nasa.gov/apod/image/2508/CirX1_English_960.jpg",
            media_type: "image",
            service_version: "v1",
            title: "Cir X-1: Jets in the Africa Nebula",
            url: "https://apod.nasa.gov/apod/image/2508/CirX1_English_960.jpg"
        )
        let sampleAPOD2 = APOD(
            date: "2025-09-04",
            explanation: "Magnificent spiral galaxy NGC 4565 is viewed edge-on from planet Earth. ...",
            hdurl: "https://apod.nasa.gov/apod/image/2509/NGC4565_APOD_sRGB.jpg",
            media_type: "image",
            service_version: "v1",
            title: "NGC 4565: Galaxy on Edge",
            url: "https://apod.nasa.gov/apod/image/2509/NGC4565_APOD_sRGB1024.jpg"
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
