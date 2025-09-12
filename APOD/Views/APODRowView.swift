import SwiftUI

struct APODRowView: View {
    let apod: APOD
    
    var body: some View {
        HStack {
            if let urlString = apod.url,
               let url = URL(string: urlString),
               apod.media_type == "image" {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 60, height: 60)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                    case .failure:
                        Color.gray.frame(width: 60, height: 60)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading) {
                Text(apod.title ?? "No title")
                    .font(.headline)
                Text(apod.date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
