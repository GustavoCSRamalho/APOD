import SwiftUI

@main
struct NasaAPODApp: App {
    var body: some Scene {
        WindowGroup {
            let apiKey = "9224k53Nc8g0NDd5nyvZl4z3vzSX21LLH7zjMIhI"
            let service = APODService(apiKey: Bundle.main.infoDictionary?["API_KEY"] as? String ?? apiKey)
            let viewModel = APODViewModel(service: service)
            
            HomeView(viewModel: viewModel)
        }
    }
}
