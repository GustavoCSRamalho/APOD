import SwiftUI

struct APODDetailView: View {
    let apod: APOD
    @EnvironmentObject var favVM: FavoritesViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(apod.title ?? "No title")
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
                    Text("Media not available")
                        .foregroundColor(.secondary)
                }
                
                Text(apod.explanation ?? "")
                    .font(.body)
                
                Text("Date: \(apod.date)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    if favVM.isFavorited(apod: apod) {
                        if let fav = favVM.favorites.first(where: { $0.date == apod.date }) {
                            favVM.removeFavorite(fav)
                        }
                    } else {
                        favVM.addFavorite(apod: apod)
                    }
                }) {
                    Text(favVM.isFavorited(apod: apod) ? "Unfavorite" : "Favorite")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(favVM.isFavorited(apod: apod) ? Color.red : Color.blue)
                        .cornerRadius(8)
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            favVM.fetchFavorites()
        }
    }
}
