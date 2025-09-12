import SwiftUI

struct APODDetailView: View {
    let apod: APOD

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(apod.title ?? "No title")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)

                if let urlString = apod.url, let url = URL(string: urlString), apod.media_type == "image" {
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
                            Color.gray
                                .frame(height: 200)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Text("Media not available or is a video")
                        .foregroundColor(.secondary)
                }

                Text(apod.explanation ?? "")
                    .font(.body)

                Text("Date: \(apod.date)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
