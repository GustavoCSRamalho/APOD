import Foundation

@MainActor
protocol FavoritesRepositoryProtocol: AnyObject {
    func fetchFavorites() -> [APOD]
    func addFavorite(_ apod: APOD)
    func removeFavorite(_ apod: APOD)
    func isFavorited(_ apod: APOD) -> Bool
}
