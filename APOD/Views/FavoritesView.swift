import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    
    var body: some View {
        List {
            if favoritesVM.favorites.isEmpty {
                Text(AppStrings.Favorites.emptyMessage)
                    .foregroundColor(.secondary)
            } else {
                ForEach(favoritesVM.favorites, id: \.date) { favAPOD in
                    NavigationLink(
                        destination: APODDetailView(apod: favAPOD)
                            .environmentObject(favoritesVM)
                    ) {
                        APODRowView(apod: favAPOD)
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .navigationTitle(AppStrings.Favorites.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton()
        }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let apod = favoritesVM.favorites[index]
            favoritesVM.removeFavorite(apod)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(FavoritesViewModel(repository: MockFavoritesRepository()))
    }
}
