import SwiftUI

struct APODListView: View {
    @StateObject var viewModel: APODListViewModel
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    
    var body: some View {
        List {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView(AppStrings.List.progressLoading)
            case .loaded(let apods):
                ForEach(apods, id: \.date) { apod in
                    NavigationLink(destination: APODDetailView(apod: apod)
                                    .environmentObject(favoritesVM)) {
                        APODRowView(apod: apod)
                    }
                }
            case .failed(let error):
                Text("\(AppStrings.List.errorPrefix)\(error)")
            }
        }
        .navigationTitle(AppStrings.List.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadLastDays()
        }
    }
}

struct APODListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockService = MockAPODService()
        let listVM = APODListViewModel(service: mockService)
        let favoritesVM = FavoritesViewModel(repository: MockFavoritesRepository())
        
        return NavigationView {
            APODListView(viewModel: listVM)
                .environmentObject(favoritesVM)
        }
    }
}
