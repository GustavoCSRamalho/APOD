import SwiftUI

struct HomeView: View {
    @StateObject private var vm: APODViewModel

    init(viewModel: APODViewModel) {
        _vm = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            content
                .navigationTitle("NASA APOD")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink("List") {
                            let service = APODService(apiKey: Bundle.main.infoDictionary?["API_KEY"] as? String ?? String())
                            let listVM = APODListViewModel(service: service)
                            APODListView(viewModel: listVM)
                        }
                    }
                }
        }
        .task {
            await vm.loadToday()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle:
            ProgressView("Ready")
        case .loading:
            ProgressView("Carregando...")
        case .loaded(let apod):
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
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(12)
                            case .failure:
                                Color.gray
                                    .frame(height: 200)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Text("Media not available or is a video.")
                    }
                    Text(apod.explanation ?? "")
                        .font(.body)
                }
                .padding()
            }
        case .failed(let msg):
            VStack {
                Text("Erro: \(msg)")
                Button("Tentar novamente") {
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
        let vm = APODViewModel(service: MockAPODService())
        HomeView(viewModel: vm)
    }
}
