import CoreImage
import Kingfisher
import SwiftUI

@MainActor
struct MangaDetailScreen: View {
    @EnvironmentObject var windowObserver: WindowObserver
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @ObservedObject private var mangaStore = MangaStore.shared
    @StateObject private var viewModel = MangaDetailScreenViewModel()

    @State private var animate = false
    @State private var isDismissing = false
    @State private var isLightCoverColor = false
    @State private var onHoverOverBackButton = false

    private var path: Binding<NavigationPath>
    private var mangaSlug: String
    private var dismiss: (() -> Void)?
    private var selectedChapterListItem: ((ChapterNavigation) -> Void)?

    init(path: Binding<NavigationPath>, mangaSlug: String, selectedChapterListItem: ((ChapterNavigation) -> Void)? = nil, dismiss: (() -> Void)? = nil) {
        self.path = path
        self.mangaSlug = mangaSlug
        self.selectedChapterListItem = selectedChapterListItem
        self.dismiss = dismiss
    }

    private func handleNavigation(chapterId: String, currentChapterImageId: String? = nil) {
        let chapterNavigation = ChapterNavigation(chapterId: chapterId, currentChapterImageId: currentChapterImageId)

        selectedChapterListItem?(chapterNavigation)
        path.wrappedValue.append(chapterNavigation)
    }

    @ViewBuilder
    private func continueButton(mangaReadState: MangaReadState?) -> some View {
        let colors = mangaStore.prominentColors[mangaSlug]?.map { $0.lighter() } ?? []
        let isLightColor = mangaStore.averageCoverColors[mangaSlug]?.isLightColor ?? true
        let defaultColors: [Color] = [.black, .gray, .black]

        if let mangaReadState {
            Button("Continue Chap. \(mangaReadState.chapterNumber)".uppercased()) {
                handleNavigation(chapterId: mangaReadState.chapterHid, currentChapterImageId: mangaReadState.currentChapterImageId)
            }
            .buttonStyle(.rainbow(colors: isLightColor ? defaultColors : colors))
        } else if let firstChapterId = viewModel.mangaDetail?.firstChapterId, !viewModel.chapterItems.isEmpty {
            Button("Start reading".uppercased()) {
                handleNavigation(chapterId: firstChapterId, currentChapterImageId: nil)
            }
            .buttonStyle(.rainbow(colors: isLightColor ? defaultColors : colors))
        }
    }

    @ViewBuilder
    private func coverImageView(geometry _: GeometryProxy) -> some View {
        if let coverViewModel = viewModel.mangaDetail?.coverViewModel, let downloadURL = coverViewModel.downloadURL {
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
                .frame(maxWidth: CGFloat(coverViewModel.w))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: .black, radius: 9)
        }
    }

    private var headerSection: some View {
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

    private func coverSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            coverImageView(geometry: geometry)

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
    }

    private var chapterItemView: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.chapterItems.enumerated()), id: \.element.id) { index, chapterItem in
                ChapterItemView(chapterItem: chapterItem,
                                isFirst: index == 0,
                                isLast: index == viewModel.chapterItems.endIndex - 1,
                                onChapterSelect: { listItem in
                                    handleNavigation(chapterId: listItem.id)
                                })
            }
        }
        .animation(.easeInOut(duration: 0.25)) // Fix animation warning find a suited value to activate animation
        .transition(.move(edge: .top))
    }

    private var chaptersButton: some View {
        Button("Chapters") {
            path.wrappedValue.append(viewModel.chapterItems)
        }
        .buttonStyle(.mangaButtonStyle)
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                if horizontalSizeClass == .compact, !viewModel.chapterItems.isEmpty, !viewModel.isLoading {
                    chaptersButton
                }
                
                continueButton(mangaReadState: viewModel.mangaReadState)
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

    private var customNavigationView: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .padding(16)
                    .background(onHoverOverBackButton ? .black.opacity(0.2) : .clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isDismissing = true
                        dismiss?()
                    }
                    .onHover { hover in
                        withAnimation(.easeInOut(duration: 0.25)) {
                            onHoverOverBackButton = hover
                        }
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
        .foregroundStyle(.white)
        .ignoresSafeArea()
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    VStack(spacing: 16) {
                        if viewModel.isLoading, !(mangaStore.prominentColors[mangaSlug]?.isEmpty ?? true) {
                            ProgressView()
                        } else {
                            headerSection

                            DynamicStack(alignment: .top, spacing: 16) {
                                coverSection(geometry: geometry)
                                contentSection
                            }
                            .padding(.horizontal, 16)

                            #if os(macOS)
                                Spacer()
                            #endif
                        }
                    }
                    .padding(.top, horizontalSizeClass == .compact ? 8 : 16)
                    .frame(width: horizontalSizeClass == .compact ? geometry.size.width : geometry.size.width * 0.85)
                }
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
                .padding(16)
            }
            .animation(.easeInOut(duration: 0.25), value: animate)
            .frame(width: geometry.size.width)
            .background {
                if let colors = mangaStore.prominentColors[mangaSlug], !colors.isEmpty {
                    FloatingCloudsView(colors: colors)
                        .ignoresSafeArea()
                }
            }
            #if os(macOS)
            .clipped() // Prevents FloatingCloudsView to be shown first when screen is Appearing
            #endif
            .background {
                if let coverColor = mangaStore.averageCoverColors[mangaSlug] {
                    coverColor
                        .ignoresSafeArea()
                        .onAppear {
                            isLightCoverColor = coverColor.isLightColor
                        }
                } else {
                    Color("background", bundle: Bundle.main)
                        .ignoresSafeArea()
                }
            }
            .task(priority: .userInitiated) {
                if viewModel.mangaDetail == nil {
                    await viewModel.fetchData(mangaSlug: mangaSlug)
                }

                await viewModel.getMangaReadState(slug: mangaSlug)
            }
            // Negating check so its just not available for macOS
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
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
            #else
            .overlay {
                        customNavigationView
                    }
                    .onChange(of: windowObserver.windowIsResizing) { _, isResizing in
                        animate = !isResizing
                    }
            #endif
                    .foregroundStyle(isLightCoverColor ? .black : .white)
                    .tint(isLightCoverColor ? .black : .white)
        }
    }
}
