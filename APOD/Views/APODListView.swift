import SwiftUI

struct APODListView: View {
    @StateObject private var vm: APODListViewModel

    init(viewModel: APODListViewModel) {
        _vm = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            content
                .navigationTitle("Last APODs")
        }
        .task {
            await vm.loadLastDays()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle:
            ProgressView("Ready")
        case .loading:
            ProgressView("Loading...")
        case .loaded(let apods):
            List(apods) { apod in
                NavigationLink(destination: APODDetailView(apod: apod)) {
                    HStack {
                        if let urlString = apod.url, let url = URL(string: urlString), apod.media_type == "image" {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 80, height: 80)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipped()
                                        .cornerRadius(8)
                                case .failure:
                                    Color.gray
                                        .frame(width: 80, height: 80)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Color.gray
                                .frame(width: 80, height: 80)
                        }
                        VStack(alignment: .leading) {
                            Text(apod.title ?? "No title")
                                .font(.headline)
                                .lineLimit(2)
                            Text(apod.date)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        case .failed(let msg):
            VStack {
                Text("Error: \(msg)")
                Button("Try Again") {
                    Task { await vm.loadLastDays() }
                }
            }
        }
    }
}

struct APODListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockService = MockAPODService()
        let vm = APODListViewModel(service: mockService, lastDays: 5)
        APODListView(viewModel: vm)
    }
}
