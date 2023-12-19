import CoreImage
import Kingfisher
import SwiftUI

@MainActor
struct MangaDetailScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @ObservedObject var manga: MangaViewModel
    var dismiss: (() -> Void)? = nil
    
    @StateObject private var viewModel = MangaDetailScreenViewModel()
    @State private var animate = false
    @State private var isDismissing = false
    @State private var selectedChapter: ChapterListItem?
    
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
        VStack {
            Text(manga.title)
                .font(horizontalSizeClass == .compact ? .body : .largeTitle)
                .bold()

            if let titles = manga.mdTitles {
                Text(titles.joined(separator: horizontalSizeClass == .compact ? "\n" : " | "))
                    .multilineTextAlignment(.leading)
                    .font(horizontalSizeClass == .compact ? .body : .title2)
            }

            HStack {
                if let year = manga.year {
                    Text("Year: ") + Text(String(year))
                }

                if let authors = viewModel.mangaDetail?.authors, !authors.isEmpty {
                    Text("Authors: ") + Text(authors.map(\.name).joined(separator: ", "))
                }
            }
            .font(horizontalSizeClass == .compact ? .body : .title2)
        }
    }

    private var coverSection: some View {
        VStack {
            coverImage
            if let artists = viewModel.mangaDetail?.artists.map(\.name), !artists.isEmpty {
                HStack {
                    Text("Artists: ") + Text(artists.joined(separator: ", "))
                }
                .font(horizontalSizeClass == .compact ? .body : .title2)
            }
            Spacer()
        }
    }

    private var chapterItemView: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.chapterItems.enumerated()), id: \.element.id) { index, chapterItem in
                ChapterItemView(chapterItem: chapterItem,
                                isFirst: index == 0,
                                isLast: index == viewModel.chapterItems.endIndex - 1) { chapterListItem in
                    
                }
            }
        }
        .animation(.easeInOut(duration: 0.25)) // Fix animation warning finde a suited value to activate animation
        .transition(.move(edge: .top))
    }

    #warning("Move logic into MangaDetailViewModel")
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let description = viewModel.mangaDetail?.comic.description {
                ForEach(Array(description.trimmingCharacters(in: .whitespacesAndNewlines).split(whereSeparator: { $0.isNewline }).enumerated()), id: \.offset) { _, line in
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

            VStack {
                if !viewModel.chapterItems.isEmpty, horizontalSizeClass != .compact {
                    chapterItemView
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
                    .padding(16)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isDismissing = true
                        dismiss?()
                    }
                Spacer()
            }
            Spacer()
        }
        .foregroundStyle(manga.isLightCoverColor ? .black : .white)
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
                                .padding(.horizontal, 8)
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
                    Spacer()
                }
                .frame(minHeight: geometry.size.height)
                .padding(.horizontal, 16)
            }
            .foregroundStyle(manga.isLightCoverColor ? .black : .white)
            .background {
                FloatingCloudsView(colors: manga.prominentColors)
            }
            .background {
                manga.avrageCoverColor?.opacity(0.5)
                    .ignoresSafeArea()
            }
            .background {
                Color("background", bundle: Bundle.main)
                    .ignoresSafeArea()
            }
            .frame(width: geometry.size.width)
            .task(priority: .background) {
                await viewModel.fetchData(mangaSlug: manga.slug)
            }
            .toolbar {
                if horizontalSizeClass == .compact, !viewModel.isLoading {
                    ToolbarItem(placement: .automatic) {
                        NavigationLink {
                            ScrollView {
                                chapterItemView
                                    .padding(16)
                            }
                            .background {
                                FloatingCloudsView(colors: manga.prominentColors)
                                    .ignoresSafeArea()
                            }
                            .background {
                                manga.avrageCoverColor
                                    .ignoresSafeArea()
                                    .animation(.easeIn, value: isDismissing == false)
                            }

                        } label: {
                            Text("Start Reading")
                        }
                    }
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
