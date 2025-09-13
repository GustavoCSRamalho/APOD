import SwiftUI
import Kingfisher

struct APODRowView: View {
    let apod: APOD
    
    var body: some View {
        HStack {
            if let urlString = apod.url,
               let url = URL(string: urlString),
               apod.media_type == "image" {
                KFImage(url)
                    .placeholder {
                        ProgressView()
                            .frame(width: 60, height: 60)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.secondary)
                    .accessibilityIdentifier("rowPhoto")
            }
            
            VStack(alignment: .leading) {
                Text(apod.title ?? AppStrings.Row.noTitle)
                    .accessibilityIdentifier("rowTitle")
                    .font(.headline)
                Text(apod.date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .accessibilityIdentifier("rowDate")
            }
        }
    }
}

struct APODRowView_Previews: PreviewProvider {
    static var previews: some View {
        let mockAPOD = APOD(
            date: "2025-09-13",
            explanation: "Mock explanation for preview purposes.",
            hdurl: nil,
            media_type: "image",
            service_version: "v1",
            title: "Mock APOD Row",
            url: "https://via.placeholder.com/150"
        )
        
        APODRowView(apod: mockAPOD)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
