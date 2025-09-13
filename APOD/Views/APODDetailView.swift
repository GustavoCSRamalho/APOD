import SwiftUI

struct APODDetailView: View {
    let apod: APOD
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(apod.title ?? "No title")
                    .font(.title)
                    .bold()
                    .accessibilityIdentifier("detailTitle")
                
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
                                    .accessibilityIdentifier("detailPhoto")
                            case .failure:
                                Color.gray.frame(height: 200)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                } else {
                    Text("Media not available")
                        .foregroundColor(.secondary)
                }
                
                Text(apod.explanation ?? "")
                    .font(.body)
                    .accessibilityIdentifier("detailExplanation")
                
                Text("Date: \(apod.date)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .accessibilityIdentifier("detailDate")
                
                Button(action: {
                    if favoritesVM.isFavorited(apod: apod) {
                        if let fav = favoritesVM.favorites.first(where: { $0.date == apod.date }) {
                            favoritesVM.removeFavorite(fav)
                        }
                    } else {
                        favoritesVM.addFavorite(apod: apod)
                    }
                }) {
                    Text(favoritesVM.isFavorited(apod: apod) ? "Unfavorite" : "Favorite")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(favoritesVM.isFavorited(apod: apod) ? Color.red : Color.blue)
                        .cornerRadius(8)
                        .accessibilityIdentifier("detailFavorites")
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            favoritesVM.fetchFavorites()
        }
    }
}

struct APODDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockAPOD = APOD(
            date: "2025-09-03",
            explanation: "How soon do jets form when a supernova gives birth to a neutron star?  The Africa Nebula provides clues. ...",
            hdurl: "https://apod.nasa.gov/apod/image/2508/CirX1_English_960.jpg",
            media_type: "image",
            service_version: "v1",
            title: "Cir X-1: Jets in the Africa Nebula",
            url: "https://apod.nasa.gov/apod/image/2508/CirX1_English_960.jpg"
        )
        
        let favoritesVM = FavoritesViewModel(repository: MockFavoritesRepository())
        
        NavigationView {
            APODDetailView(apod: mockAPOD)
                .environmentObject(favoritesVM)
        }
    }
}
