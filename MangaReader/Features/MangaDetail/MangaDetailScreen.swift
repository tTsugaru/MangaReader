import CoreImage
import Kingfisher
import SwiftUI

@MainActor
struct MangaDetailScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @StateObject var viewModel = MangaDetailScreenViewModel()

    @State private var animate = false
    @ObservedObject var manga: MangaViewModel

    var dismiss: (() -> Void)? = nil
    @State var isDismissing = false

    init(manga: MangaViewModel, dismiss: (() -> Void)? = nil) {
        self.manga = manga
        self.dismiss = dismiss
    }

    private var coverImage: some View {
        KFImage(manga.imageDownloadURL)
            .fade(duration: 0.2)
            .startLoadingBeforeViewAppear()
            .onSuccess { populateMangaColors($0) }
            .onFailure { error in
                print(error)
            }
            .placeholder {
                ProgressView()
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
                .font(horizontalSizeClass == .compact ? .body : .largeTitle)
                .bold()

            if let titles = manga.mdTitles {
                Text(titles.joined(separator: horizontalSizeClass == .compact ? "\n" : " | "))
                    .multilineTextAlignment(.leading)
                    .font(horizontalSizeClass == .compact ? .body : .title2)
            }
        }
    }

    private var coverSection: some View {
        VStack {
            coverImage
            Spacer()
        }
    }

    #warning("Move logic into MangaDetailViewModel")
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let description = viewModel.mangaDetail?.comic.description {
                ForEach(description.trimmingCharacters(in: .whitespacesAndNewlines).split(whereSeparator: { $0.isNewline }), id: \.count) { line in
                    if line.contains("http") {
                        Text(.init(String(line)))
                            .font(.body)
                            .underline()
                            .tint(manga.isLightCoverColor ? .black : .white)
                    } else {
                        Text(.init(String(line)))
                            .font(.body)
                    }
                }
            }

            Spacer()
        }
    }
    
    private var closeButton: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture {
                        isDismissing = true
                        dismiss?()
                    }
                    .padding(16)
                    .contentShape(Rectangle())
                
                Spacer()
            }
            Spacer()
        }
        .ignoresSafeArea()
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 16) {
                    headerSection

                    DynamicStack(spacing: 8) {
                        coverSection

                        if !manga.prominentColors.isEmpty, manga.avrageCoverColor != nil {
                            contentSection
                        } else {
                            HStack {
                                Spacer()
                                VStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                }
                .frame(minHeight: geometry.size.height)
                .padding(.horizontal, 16)
            }
            .foregroundStyle(manga.isLightCoverColor ? .black : .white)
            .background {
                FloatingCloudsView(colors: manga.prominentColors)
                    .animation(.easeIn, value: isDismissing == false)
            }
            .background {
                manga.avrageCoverColor
                    .ignoresSafeArea()
                    .animation(.easeIn, value: isDismissing == false)
            }
            .background {
                Color("background", bundle: Bundle.main)
                    .ignoresSafeArea()
            }
            .frame(width: geometry.size.width)
            .task(priority: .background) {
                if viewModel.mangaDetail == nil {
                    await viewModel.getMangaDetail(slug: manga.slug)
                }
            }
            // Navigation for macOS
            .overlay {
                if dismiss != nil {
                    closeButton
                }
            }
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
