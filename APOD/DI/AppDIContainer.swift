import Foundation
import SwiftUI
import CoreData

final class AppDIContainer {

    // Core Data
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NasaAPODModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData load error: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext { persistentContainer.viewContext }

    // Services
    lazy var apodService: APODServiceProtocol = {
        let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String ?? "9224k53Nc8g0NDd5nyvZl4z3vzSX21LLH7zjMIhI"
        return APODService(apiKey: apiKey)
    }()

    @MainActor
    lazy var coreService: FavoritesRepositoryProtocol = {
        FavoritesRepository(context: context)
    }()

    // MARK: - ViewModels
    @MainActor
    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(repository: coreService)
    }

    @MainActor
    func makeHomeViewModel() -> APODViewModel {
        APODViewModel(service: apodService)
    }

    @MainActor
    func makeListViewModel() -> APODListViewModel {
        APODListViewModel(service: apodService)
    }

    // MARK: - Views
    @MainActor
    func makeHomeView() -> some View {
        let favoritesVM = makeFavoritesViewModel()
        let homeVM = makeHomeViewModel()
        return HomeView(viewModel: homeVM)
            .environmentObject(favoritesVM)
    }

    @MainActor
    func makeFavoritesView() -> some View {
        let favoritesVM = makeFavoritesViewModel()
        return FavoritesView()
            .environmentObject(favoritesVM)
    }

    @MainActor
    func makeListView() -> some View {
        let favoritesVM = makeFavoritesViewModel()
        let listVM = makeListViewModel()
        return APODListView(viewModel: listVM)
            .environmentObject(favoritesVM)
    }
}
