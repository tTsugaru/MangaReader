import CoreImage
import Kingfisher
import SwiftUI

@MainActor
class MangaDetailScreenViewModel: ObservableObject {
    func getMangaDetail(slug _: String) {}
}

@MainActor
struct MangaDetailScreen: View {
    @State private var animate = false
    @ObservedObject var manga: MangaViewModel

    private var coverImage: some View {
        KFImage(manga.imageDownloadURL)
            .fade(duration: 0.2)
            .startLoadingBeforeViewAppear()
            .onSuccess { populateMangaColors($0) }
            .onFailure { error in
                print(error)
            }
            .placeholder {
                Color.black
                    .frame(width: 500)
            }
            .resizable()
            .scaledToFit()
            .frame(minWidth: 100, maxWidth: 500)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 5)
            .animation(.none, value: manga)
    }

    private var headerSection: some View {
        Group {
            Text(manga.title)
                .font(.largeTitle)
                .bold()

            if let titles = manga.mdTitles {
                Text(titles.joined(separator: " | "))
                    .multilineTextAlignment(.leading)
                    .font(.title2)
            }
        }
        .shadow(color: Color.black, radius: 5)
    }

    private var coverSection: some View {
        VStack {
            coverImage
            Spacer()
        }
    }

    private var contentSection: some View {
        VStack(alignment: .leading) {
            if let description = manga.desc {
                Text(description)
            }

            Spacer()
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    headerSection

                    DynamicHStack {
                        coverSection
                        
                        if !manga.prominentColors.isEmpty, manga.avrageCoverColor != nil {
                            contentSection
                        } else {
                            VStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                        
                        Spacer()
                    }
                }
                .frame(minHeight: geometry.size.height)
                .padding(.horizontal, 16)
            }
            .background {
                FloatingCloudsView(colors: manga.prominentColors)
            }
            .background {
                manga.avrageCoverColor
                    .ignoresSafeArea()
            }
            .background {
                Color("background", bundle: Bundle.main)
                    .ignoresSafeArea()
            }
            .frame(width: geometry.size.width)
            .navigationTitle(manga.title)
        }
    }

    func populateMangaColors(_ result: RetrieveImageResult) {
        Task.detached(priority: .background) {
            let image = result.image
            let prominentColors = image.prominentColors
            let avrageCoverColor = image.avrageColor

            Task { @MainActor in
                withAnimation(.easeInOut) {
                    manga.prominentColors = prominentColors
                    manga.avrageCoverColor = avrageCoverColor
                }
            }
        }
    }
}
