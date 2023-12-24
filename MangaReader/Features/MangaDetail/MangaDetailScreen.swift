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

    #warning("deduplicate code")
    @ViewBuilder
    private func continueButton(mangaReadState: MangaReadState) -> some View {
        if let colors = mangaStore.prominentColors[mangaSlug], let isLightColor = mangaStore.averageCoverColors[mangaSlug]?.isLightColor {
            Button("Continue Chap. \(mangaReadState.chapterNumber)".uppercased()) {
                handleNavigation(chapterId: mangaReadState.chapterHid, currentChapterImageId: mangaReadState.currentChapterImageId)
            }
            .buttonStyle(.rainbow(colors: isLightColor ? [.black, .gray, .black] : colors.map { $0.lighter() }))
        } else {
            Button("Continue Chap. \(mangaReadState.chapterNumber)".uppercased()) {
                handleNavigation(chapterId: mangaReadState.chapterHid, currentChapterImageId: mangaReadState.currentChapterImageId)
            }
            .buttonStyle(.rainbow)
        }
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
                .shadow(color: .black, radius: 9)
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
                    Text("🗓️ Year: ") + Text(String(year))
                }

                if let authors = viewModel.mangaDetail?.authors, !authors.isEmpty {
                    Text("✒️ Authors: ") + Text(authors)
                }
            }
            .font(horizontalSizeClass == .compact ? .body : .title2)
        }
    }

    private var coverSection: some View {
        VStack(spacing: 0) {
            coverImageView()

            if let artists = viewModel.mangaDetail?.artists, !artists.isEmpty {
                HStack {
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
            
            if let mangaReadState = viewModel.mangaReadState {
                continueButton(mangaReadState: mangaReadState)
                    .padding(.top, 16)
            }
            Spacer()
        }
    }

    private var chapterItemView: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.chapterItems.enumerated()), id: \.element.id) { index, chapterItem in
                ChapterItemView(chapterItem: chapterItem,
                                isFirst: index == 0,
                                isLast: index == viewModel.chapterItems.endIndex - 1, onChapterSelect: { listItem in
                                    handleNavigation(chapterId: listItem.id)
                                })
            }
        }
        .animation(.easeInOut(duration: 0.25), value: animate) // Fix animation warning finde a suited value to activate animation
        .transition(.move(edge: .top))
    }

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let description = viewModel.mangaDetail?.sanitizedDescription {
                VStack(alignment: .leading) {
                    ForEach(Array(description.enumerated()), id: \.offset) { _, line in
                        if line.contains("http") {
                            Text(.init(String(line)))
                                .font(.body)
                                .underline()
                                .tint(isLightCoverColor ? .black : .white)
                        } else {
                            Text(.init(String(line)))
                                .font(.body)
                        }
                    }
                }
                .padding(16)
                .background {
                    Color.black.opacity(0.3)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
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

    private var customNavigationView: some View {
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

                            DynamicStack(spacing: 16) {
                                coverSection
                                contentSection
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .frame(width: horizontalSizeClass == .compact ? geometry.size.width : geometry.size.width * 0.85)
                }
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .onDisappear {
                print("Disappear")
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
            .clipped() // Prevents FloatingCloudsView to be shown first
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
                await viewModel.getMangaReadState(slug: mangaSlug)
                await viewModel.fetchData(mangaSlug: mangaSlug)
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
                CompactChapterListScreen(path: path, isLoading: $viewModel.isLoading, mangaSlug: mangaSlug, chapterListItems: chapterListItems)
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
