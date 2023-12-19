import CoreImage
import Kingfisher
import SwiftUI

@MainActor
struct MangaDetailScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var path: Binding<NavigationPath>
    var mangaSlug: String
    var dismiss: (() -> Void)? = nil

    @StateObject private var viewModel = MangaDetailScreenViewModel()
    @State private var animate = false
    @State private var isDismissing = false
    @State private var selectedChapter: ChapterListItem?

    init(path: Binding<NavigationPath>, mangaSlug: String, dismiss: (() -> Void)? = nil) {
        self.path = path
        self.mangaSlug = mangaSlug
        self.dismiss = dismiss
    }

    @ViewBuilder
    private func coverImageView() -> some View {
        if let downloadURL = viewModel.mangaDetail?.imageDownloadURL {
            KFImage(downloadURL)
                .fade(duration: 0.2)
                .startLoadingBeforeViewAppear()
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
        }
    }

    private var headerSection: some View {
        VStack {
            if let titles = viewModel.mangaDetail?.alternativeTitles {
                Text(titles)
                    .multilineTextAlignment(.leading)
                    .font(horizontalSizeClass == .compact ? .body : .title2)
            }

            DynamicStack {
                if let year = viewModel.mangaDetail?.year {
                    Text("Year: ") + Text(String(year))
                }

                if let authors = viewModel.mangaDetail?.authors, !authors.isEmpty {
                    Text("Authors: ") + Text(authors)
                }
            }
            .font(horizontalSizeClass == .compact ? .body : .title2)
        }
    }

    private var coverSection: some View {
        VStack {
            coverImageView()

            if let artists = viewModel.mangaDetail?.artists, !artists.isEmpty {
                HStack {
                    Text("Artists: ") + Text(artists)
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
                                isLast: index == viewModel.chapterItems.endIndex - 1)
                { _ in
                }
            }
        }
        .animation(.easeInOut(duration: 0.25)) // Fix animation warning finde a suited value to activate animation
        .transition(.move(edge: .top))
    }

    #warning("Move logic into MangaDetailViewModel")
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let description = viewModel.mangaDetail?.description {
                ForEach(Array(description.trimmingCharacters(in: .whitespacesAndNewlines).split(whereSeparator: { $0.isNewline }).enumerated()), id: \.offset) { _, line in
                    if line.contains("http") {
                        Text(.init(String(line)))
                            .font(.body)
                            .underline()
//                            .tint(viewModel.mangaDetail.isLightCoverColor ? .black : .white)
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

                if let title = viewModel.mangaDetail?.title {
                    Text(title)
                        .font(horizontalSizeClass == .compact ? .title : .largeTitle)
                        .bold()
                }

                Spacer()
            }
            .background {
                #if os(macOS)
                    BlurView(material: .toolTip, blendingMode: .withinWindow)
                #endif
            }
            Spacer()
        }
//        .foregroundStyle(manga.isLightCoverColor ? .black : .white)
        .ignoresSafeArea()
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 16) {
                    if viewModel.isLoading {
                        Spacer()
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        Spacer()

                    } else {
                        headerSection

                        DynamicStack(spacing: 8) {
                            coverSection

                            contentSection
                                .padding(.horizontal, 8)

                            Spacer()
                        }
                        Spacer()
                    }
                }
                .frame(minHeight: geometry.size.height)
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .frame(width: geometry.size.width)
//            .background {
//                FloatingCloudsView(colors: manga.prominentColors)
//                    .ignoresSafeArea()
//            }
//            .background {
//                manga.avrageCoverColor?.opacity(0.5)
//                    .ignoresSafeArea()
//            }
            .background {
                Color("background", bundle: Bundle.main)
                    .ignoresSafeArea()
            }
            .task(priority: .userInitiated) {
                await viewModel.fetchData(mangaSlug: "00-one-piece")
            }
            // Navigation for macOS
            .overlay {
                if dismiss != nil {
                    closeButton
                }
            }
            // Negating check so its just not available for macOS
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                if horizontalSizeClass == .compact {
                    ToolbarItem(placement: .automatic) {
                        Button(action: {
                            path.wrappedValue.append(viewModel.chapterItems)
                        }, label: {
                            Text("Start Reading")
                        })
                    }
                }

                if let title = viewModel.mangaDetail?.title {
                    ToolbarItem(placement: .principal) {
                        Text(title)
                            .multilineTextAlignment(.center)
                            .bold()
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    CustomBackButton()
                }
            }
            .navigationDestination(for: [ChapterListItem].self) { chapterListItems in
                CompactChapterListScreen(isLoading: $viewModel.isLoading, chapterListItems: chapterListItems)
            }
            #endif
//            .foregroundStyle(manga.isLightCoverColor ? .black : .white)
//            .tint(manga.isLightCoverColor ? .black : .white)
        }
    }
}
