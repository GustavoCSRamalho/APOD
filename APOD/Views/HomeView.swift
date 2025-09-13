import SwiftUI

struct HomeView: View {
    @StateObject private var vm: APODViewModel
    @EnvironmentObject var favoritesVM: FavoritesViewModel

    @State private var showingList = false
    @State private var showingFavorites = false
    
    init(viewModel: APODViewModel) {
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle(AppStrings.Home.title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(AppStrings.Home.menuList) { showingList = true }
                            Button(AppStrings.Home.menuFavorites) { showingFavorites = true }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                        .accessibilityIdentifier("optionsMenu")
                    }
                }
                .task {
                    await vm.loadToday()
                    favoritesVM.fetchFavorites()
                }
                .sheet(isPresented: $showingList) {
                    let listVM = AppDIContainer().makeListViewModel()
                    NavigationView {
                        APODListView(viewModel: listVM)
                            .environmentObject(favoritesVM)
                    }
                }
                .sheet(isPresented: $showingFavorites) {
                    NavigationView {
                        AppDIContainer().makeFavoritesView()
                            .environmentObject(favoritesVM)
                    }
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle:
            ProgressView(AppStrings.Home.progressIdle)
        case .loading:
            ProgressView(AppStrings.Home.progressLoading)
        case .loaded(let apod):
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(apod.title ?? AppStrings.Row.noTitle)
                        .font(.title)
                        .bold()
                    
                    if let urlString = apod.url, let url = URL(string: urlString) {
                        if apod.media_type == "image" {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(maxWidth: .infinity, minHeight: 200)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(12)
                                case .failure:
                                    Color.gray.frame(height: 200)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else if apod.media_type == "video" {
                            Link("Open Video", destination: url)
                                .foregroundColor(.blue)
                                .padding()
                        }
                    } else {
                        Text(AppStrings.Home.mediaNotAvailable)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(apod.explanation ?? "")
                        .font(.body)
                    
                    Button {
                        if favoritesVM.isFavorited(apod: apod) {
                            if let fav = favoritesVM.favorites.first(where: { $0.date == apod.date }) {
                                favoritesVM.removeFavorite(fav)
                            }
                        } else {
                            favoritesVM.addFavorite(apod: apod)
                        }
                    } label: {
                        Text(favoritesVM.isFavorited(apod: apod) ? AppStrings.Home.unfavorite : AppStrings.Home.favorite)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(favoritesVM.isFavorited(apod: apod) ? Color.red : Color.blue)
                            .cornerRadius(8)
                    }
                    .accessibilityIdentifier("favoriteButton")
                    .padding(.top)
                }
                .padding()
            }
        case .failed(let msg):
            VStack {
                Text("\(AppStrings.Home.errorPrefix)\(msg)")
                Button(AppStrings.Home.retry) {
                    Task {
                        await vm.loadToday()
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let diContainer = AppDIContainer()
        diContainer.makeHomeView()
    }
}
