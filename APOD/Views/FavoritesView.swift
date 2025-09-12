import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favVM: FavoritesViewModel
    
    var body: some View {
        List {
            if favVM.favorites.isEmpty {
                Text("No favorites yet")
                    .foregroundColor(.secondary)
            } else {
                ForEach(favVM.favorites, id: \.date) { favAPOD in
                    NavigationLink(
                        destination: APODDetailView(apod: APOD(from: favAPOD))
                            .environmentObject(favVM)
                    ) {
                        APODRowView(apod: APOD(from: favAPOD))
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton()
        }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let apod = favVM.favorites[index]
            favVM.removeFavorite(apod)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(FavoritesViewModel())
    }
}
