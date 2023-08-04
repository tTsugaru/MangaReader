//

import SwiftUI

struct MangaListScreen: View {
    @StateObject var viewModel = MangaListViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.mangas, id: \.id) { manga in
                Text(manga.title)
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
