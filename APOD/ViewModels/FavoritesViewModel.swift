import Foundation
import CoreData
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var favorites: [FavoriteAPOD] = []
    
    private let context = CoreDataStack.shared.context
    
    func fetchFavorites() {
        let request: NSFetchRequest<FavoriteAPOD> = FavoriteAPOD.fetchRequest()
        do {
            favorites = try context.fetch(request)
        } catch {
            print("Fetch favorites failed: \(error)")
        }
    }
    
    func addFavorite(apod: APOD) {
        let fav = FavoriteAPOD(context: context)
        fav.date = apod.date
        fav.title = apod.title
        fav.explanation = apod.explanation
        fav.url = apod.url
        fav.media_type = apod.media_type
        fav.hdurl = apod.hdurl
        fav.service_version = apod.service_version
        CoreDataStack.shared.saveContext()
        fetchFavorites()
    }
    
    func removeFavorite(_ favorite: FavoriteAPOD) {
        context.delete(favorite)
        CoreDataStack.shared.saveContext()
        fetchFavorites()
    }
    
    func isFavorited(apod: APOD) -> Bool {
        favorites.contains { $0.date == apod.date }
    }
}
