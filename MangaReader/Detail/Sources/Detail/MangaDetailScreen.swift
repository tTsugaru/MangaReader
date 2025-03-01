import CoreImage
import Kingfisher
import Models
import Styles
import SwiftData
import SwiftUI
import Utility

@MainActor
public struct MangaDetailScreen: View {
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass

    @Environment(\.modelContext)
    private var modelContext

    @EnvironmentObject private var theme: Theme

    @StateObject private var viewModel = MangaDetailScreenViewModel()

    @Query private var mangaReadStates: [MangaReadState]

    @State private var isLightCoverColor = false
    @State private var onHoverOverBackButton = false
    @State private var chapterItemViewChanged = false // AnimationState
    @State private var prominentColors = [Color]()
    @State private var averageCoverColor: Color?

    private var mangaSlug: String
    private var dismiss: (() -> Void)?
    private var selectedChapterListItem: ((ChapterNavigation) -> Void)?

    public init(mangaSlug: String, selectedChapterListItem: ((ChapterNavigation) -> Void)? = nil, dismiss: (() -> Void)? = nil) {
        self.mangaSlug = mangaSlug
        self.selectedChapterListItem = selectedChapterListItem
        self.dismiss = dismiss
    }

    private func handleNavigation(chapterId: String, currentChapterImageId: String? = nil) {
        let chapterNavigation = ChapterNavigation(chapterId: chapterId, currentChapterImageId: currentChapterImageId)

        selectedChapterListItem?(chapterNavigation)
//        path.wrappedValue.append(chapterNavigation)
    }

    // MARK: Button Views

    @ViewBuilder
    private func continueButton(mangaReadState: MangaReadState?) -> some View {
        let colors = prominentColors.map { $0.lighter() }
        let defaultColors: [Color] = [.black, .gray, .black]

        if let mangaReadState, let chapterNumber = mangaReadState.chapterNumber, let chapterHid = mangaReadState.chapterHid {
            Button("Continue Chap. \(chapterNumber)".uppercased()) {
                handleNavigation(chapterId: chapterHid, currentChapterImageId: mangaReadState.currentChapterImageId)
            }
            .buttonStyle(.rainbow(colors: colors.isEmpty ? defaultColors : colors))
        } else if let firstChapterId = viewModel.mangaDetail?.firstChapterId, !viewModel.chapterItems.isEmpty {
            Button("Start reading".uppercased()) {
                handleNavigation(chapterId: firstChapterId, currentChapterImageId: nil)
            }
            .buttonStyle(.rainbow(colors: colors.isEmpty ? defaultColors : colors))
        }
    }

    private var chaptersButton: some View {
        NavigationLink("Chapters", value: viewModel.chapterItems)
            .buttonStyle(.mangaButtonStyle)
    }

    // MARK: Views

    @ViewBuilder
    private func coverImageView() -> some View {
        if let coverViewModel = viewModel.mangaDetail?.coverViewModel, let downloadURL = coverViewModel.downloadURL {
            KFImage(downloadURL)
                .onSuccess { populateMangaColors(imageResult: $0) }
                .fade(duration: 0.2)
                .startLoadingBeforeViewAppear()
                .onFailure { error in
                    logger.error("\(error)")
                }
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .scaledToFit()
                .frame(maxWidth: CGFloat(coverViewModel.width))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            if let title = viewModel.mangaDetail?.title {
                Text(title)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                    .bold()
            }

            DynamicStack {
                if let year = viewModel.mangaDetail?.year {
                    Text("🗓️ Year: ") + Text(String(year))
                }

                if let authors = viewModel.mangaDetail?.authors, !authors.isEmpty {
                    Text("✒️ Authors: ") + Text(authors)
                }
            }
            .font(horizontalSizeClass == .compact ? .body : .title2)
        }
        .padding(.horizontal, 16)
    }

    private func coverSection() -> some View {
        VStack(spacing: 0) {
            coverImageView()
                .frame(maxWidth: .infinity, alignment: .center)

            if let artists = viewModel.mangaDetail?.artists, !artists.isEmpty {
                HStack(alignment: .top) {
                    Text("✍🏻 Artists: ") + Text(artists)
                }
                .padding(8)
                .font(horizontalSizeClass == .compact ? .body : .title2)
                .background {
                    Color.black.opacity(0.3)
                        .clipShape(
                            .rect(cornerRadii: RectangleCornerRadii(topLeading: 0,
                                                                    bottomLeading: 10,
                                                                    bottomTrailing: 10,
                                                                    topTrailing: 0)
                            )
                        )
                }
            }
        }
        .compositingGroup()
        .shadow(color: .black, radius: 9)
    }

    private var chapterItemView: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.chapterItems.enumerated()), id: \.element.id) { index, chapterItem in
                ChapterItemView(chapterItem: chapterItem,
                                expand: viewModel.expandedChapterList[chapterItem.id, default: false],
                                expandingChanged: $chapterItemViewChanged,
                                isFirst: index == 0,
                                isLast: index == viewModel.chapterItems.endIndex - 1,
                                onChapterSelect: { listItem in
                                    if let listItem {
                                        handleNavigation(chapterId: listItem.id)
                                    } else {
                                        viewModel.handleExpanding(for: chapterItem.id)
                                    }
                                })
            }
        }
        .animation(.easeInOut(duration: 0.25), value: chapterItemViewChanged)
        .transition(.move(edge: .top))
    }

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                if horizontalSizeClass == .compact, !viewModel.chapterItems.isEmpty, !viewModel.isLoading {
                    chaptersButton
                }

                continueButton(mangaReadState: mangaReadStates.first(where: { $0.mangaSlug == mangaSlug }))
            }

            if let description = viewModel.mangaDetail?.sanitizedDescription {
                Text(.init(description))
                    .font(.body)
                    .tint(isLightCoverColor ? .black : .white)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background {
                        Color.black.opacity(0.3)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
            }

            if !viewModel.chapterItems.isEmpty, horizontalSizeClass != .compact {
                chapterItemView
            }
        }
    }

    // MARK: - Body

    public var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 16) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        headerSection

                        DynamicStack(alignment: .top, spacing: 16) {
                            coverSection()
                            contentSection
                        }
                        .padding(.horizontal, 16)
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                }
                .padding(.top, horizontalSizeClass == .compact ? 8 : 16)
            }
            .padding(16)
        }
        .background {
            if !prominentColors.isEmpty {
                FloatingCloudsView(colors: prominentColors)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: prominentColors)
        #if os(macOS)
            .clipped() // Prevents FloatingCloudsView to be shown first when screen is Appearing
        #endif
            .background {
                if let coverColor = averageCoverColor {
                    coverColor
                        .ignoresSafeArea()
                        .onAppear {
                            isLightCoverColor = coverColor.isLightColor
                            theme.toolbarTint = isLightCoverColor ? coverColor.darker() : coverColor.lighter()
                        }
                        .transition(.opacity)
                } else {
                    Color("background", bundle: Bundle.main)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onAppear {
                            isLightCoverColor = false
                            theme.toolbarTint = .white
                        }
                }
            }
            .animation(.easeInOut(duration: 0.25), value: averageCoverColor)
            .task(priority: .userInitiated) {
                await viewModel.fetchData(mangaSlug: mangaSlug)

                guard !mangaReadStates.contains(where: { $0.mangaSlug == mangaSlug }) else { return }
                modelContext.insert(MangaReadState(mangaSlug: mangaSlug))
                logger.debug("💾 Inserted unknown Manga - \(mangaSlug)")
            }
            .toolbar {
                if let title = viewModel.mangaDetail?.title {
                    ToolbarItem(placement: .principal) {
                        Text(title)
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .bold()
                    }
                }
            }
            .foregroundStyle(isLightCoverColor ? .black : .white)
            .tint(isLightCoverColor ? .black : .white)
    }

    private func populateMangaColors(imageResult: RetrieveImageResult) {
        Task {
            let image = imageResult.image
            let resizedImage = image.resize(width: 50, height: 50)

            guard let image = resizedImage else { return }
            let averageCoverColor = image.averageColor

            let prominentColors = await Task.detached(priority: .medium) {
                return await image.prominentColors()
            }.result.get()

            self.prominentColors = prominentColors
            self.averageCoverColor = averageCoverColor
        }
    }
}
