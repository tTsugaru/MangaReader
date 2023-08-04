import SwiftUI

struct MangaListScreen: View {
    @StateObject var viewModel = MangaListViewModel()

    #if os(iOS)
        var columns = [GridItem(), GridItem()]
    #elseif os(macOS)
        var columns = [GridItem(), GridItem(), GridItem(), GridItem()]
    #endif

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
                ForEach(viewModel.mangas, id: \.slug) { manga in
                    VStack {
                        if let coverImage = manga.image, !viewModel.isLoadingImages {
                            coverImage
                                .resizable()
                                .scaledToFit()
                        } else {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        Text(manga.title)
                    }
                }
            }
        }
        .task {
            await viewModel.getAllMangas()
        }
    }
}

#Preview {
    MangaListScreen()
}
