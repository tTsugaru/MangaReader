import Kingfisher
import SwiftUI

struct MangaDetailScreen: View {
    let manga: MangaViewModel

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                        KFImage(manga.imageDownloadURL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 500)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .shadow(radius: 5)
                        
                        Spacer()
                    }
                    .padding(16)
                    
                    Spacer()
                }
                .frame(minHeight: geometry.size.height)
            }
            .frame(width: geometry.size.width)
            .navigationTitle(manga.title)
        }
    }
}
