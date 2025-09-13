import Foundation
import CoreData
import os.log

@MainActor
final class FavoritesRepository: FavoritesRepositoryProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func fetchFavorites() -> [APOD] {
        let request: NSFetchRequest<FavoriteAPOD> = FavoriteAPOD.fetchRequest()
        do {
            let favorites = try context.fetch(request)
            return favorites.map { APOD(favorite: $0) }
        } catch {
            print("Fetch failed: \(error)")
            return []
        }
    }

    func addFavorite(_ apod: APOD) {
        let fav = FavoriteAPOD(context: context)
        fav.date = apod.date
        fav.title = apod.title
        fav.explanation = apod.explanation
        fav.url = apod.url
        fav.hdurl = apod.hdurl
        fav.service_version = apod.service_version
        fav.media_type = apod.media_type
        CoreDataStack.shared.saveContext(context: context)
    }

    func removeFavorite(_ apod: APOD) {
        let request: NSFetchRequest<FavoriteAPOD> = FavoriteAPOD.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", apod.date)
        if let favorites = try? context.fetch(request), let first = favorites.first {
            context.delete(first)
            CoreDataStack.shared.saveContext(context: context)
        }
    }

    func isFavorited(_ apod: APOD) -> Bool {
        let request: NSFetchRequest<FavoriteAPOD> = FavoriteAPOD.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", apod.date)
        return (try! context.count(for: request)) > 0
    }
}
