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
    @State private var selectedChapterItem: ChapterListItem?

    private var mangaSlug: String
    private var dismiss: (() -> Void)?
    private var selectedChapterListItem: ((ChapterNavigation) -> Void)?

    public init(mangaSlug: String, selectedChapterListItem: ((ChapterNavigation) -> Void)? = nil, dismiss: (() -> Void)? = nil) {
        self.mangaSlug = mangaSlug
        self.selectedChapterListItem = selectedChapterListItem
        self.dismiss = dismiss
    }

    // MARK: Button Views

    @ViewBuilder
    private func continueButton(mangaReadState: MangaReadState?) -> some View {
        let colors = prominentColors.map { $0.lighter() }
        let defaultColors: [Color] = [.black, .gray, .black]

        if let mangaReadState, let chapterNumber = mangaReadState.chapterNumber, let chapterHid = mangaReadState.chapterHid {
            NavigationLink("Continue Chap. \(chapterNumber)".uppercased(), value: ChapterNavigation(chapterId: chapterHid, currentChapterImageId: mangaReadState.currentChapterImageId))
                .buttonStyle(.rainbow(colors: colors.isEmpty ? defaultColors : colors))
        } else if let firstChapterId = viewModel.mangaDetail?.firstChapterId, !viewModel.chapterItems.isEmpty {
            NavigationLink("Start reading".uppercased(), value: ChapterNavigation(chapterId: firstChapterId, currentChapterImageId: nil))
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
                .shadow(color: .black, radius: 9)

            if let artists = viewModel.mangaDetail?.artists, !artists.isEmpty {
                Text("✍🏻 Artists: \(artists)")
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
                                        selectedChapterItem = listItem
                                    } else {
                                        viewModel.handleExpanding(for: chapterItem.id)
                                    }
                                })
            }
        }
        .animation(.easeInOut(duration: 0.25), value: chapterItemViewChanged)
        .transition(.move(edge: .top))
        .background {
            if let id = selectedChapterItem?.id {
                NavigationLink("", value: ChapterNavigation(chapterId: id))
                    .labelsHidden()
                    .buttonStyle(.plain)
            }
        }
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
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
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
            .frame(maxWidth: .infinity)
            .background {
                if let coverColor = averageCoverColor {
                    coverColor
                        .ignoresSafeArea()
                        .onAppear {
                            isLightCoverColor = coverColor.isLightColor
                            let tintColor = isLightCoverColor ? coverColor.darker(by: 0.5) : coverColor.lighter(by: 0.5)
                            theme.toolbarTint = tintColor
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
            .foregroundStyle(theme.toolbarTint)
            .tint(isLightCoverColor ? .black : .white)
            .onDisappear {
                theme.tabBarTint = Styles.TintColor.tabBar
            }
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
