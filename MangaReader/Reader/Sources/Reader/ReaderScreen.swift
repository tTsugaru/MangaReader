import Kingfisher
import Models
import Styles
import SwiftData
import SwiftUI

public struct ReaderScreen: View {
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass

    @Environment(\.modelContext)
    private var modelContext

    @StateObject private var viewModel = ReaderScreenViewModel()
    @State private var navigationVisibility = Visibility.hidden
    @State private var didInitiateScrollTo = false

    @Query private var mangaReadStates: [MangaReadState]

    private let chapterId: String
    private let currentChapterImageId: String?
    private let dismiss: (() -> Void)?

    public init(chapterId: String, currentChapterImageId: String? = nil, dismiss: (() -> Void)? = nil) {
        self.chapterId = chapterId
        self.currentChapterImageId = currentChapterImageId
        self.dismiss = dismiss
    }

    @ViewBuilder
    private func safeAreaBackground(geometry: GeometryProxy) -> some View {
        #if !os(macOS)
            VStack {
                if !viewModel.isLoading, navigationVisibility == .hidden {
                    BlurView(style: .systemThinMaterial)
                        .frame(width: geometry.size.width, height: geometry.safeAreaInsets.top)
                }
                Spacer()
            }
            .transition(.move(edge: .top))
            .ignoresSafeArea()
        #endif
    }

    private func chapterImage(image: ChapterImageViewModel, index: Int, proxy: ScrollViewProxy) -> some View {
        VStack {
            KFImage(image.url)
                .startLoadingBeforeViewAppear()
                .onFailure { error in
                    print(error)
                }
                .placeholder { _ in
                    Image(systemName: "arrow.circlepath")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: CGFloat(image.width), maxHeight: CGFloat(image.height))
                        .accessibilityLabel("")
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: CGFloat(image.width), maxHeight: CGFloat(image.height))
        }
        .onAppear {
            if !viewModel.isLoading, !viewModel.images.isEmpty, !didInitiateScrollTo {
                proxy.scrollTo(currentChapterImageId, anchor: .top)
                didInitiateScrollTo = true
            }
        }
        .task {
            guard !viewModel.isLoading, let mangaSlug = image.mangaSlug else { return }

            let mangaReadState = mangaReadStates.first { $0.mangaSlug == mangaSlug } ?? MangaReadState(mangaSlug: mangaSlug)
            let editedMangaReadState = viewModel.editMangaReadState(currentMangaReadState: mangaReadState)

            modelContext.insert(editedMangaReadState)
            logger.debug("Edited MangaReadState \(editedMangaReadState.mangaSlug ?? "") \(String(editedMangaReadState.chapterNumber ?? 0))")

            guard let nextChapter = viewModel.chapterDetailViewModel?.next?.hid, (viewModel.images.endIndex - 1) == index else { return }
            await viewModel.getChapterDetail(chapterId: nextChapter)
        }
    }

    public var body: some View {
        ScrollViewReader { reader in
            ScrollView {
                LazyVStack(spacing: 0) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        ForEach(Array(viewModel.images.enumerated()), id: \.offset) { index, image in
                            chapterImage(image: image, index: index, proxy: reader)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .toolbar(navigationVisibility)
            .animation(.easeInOut(duration: 0.1), value: navigationVisibility)
            .background {
                Color.black
                    .ignoresSafeArea()
            }
            .task {
                await viewModel.getChapterDetail(chapterId: chapterId)
            }
//            .overlay(safeAreaBackground(geometry: geometry))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CustomBackButton()
                }

                ToolbarItem(placement: .principal) {
                    Text(viewModel.readerTitle)
                }
            }
            .foregroundStyle(.white)
            .accessibilityAddTraits(.isButton)
            .onTapGesture {
                withAnimation {
                    navigationVisibility == .hidden ? (navigationVisibility = .visible) : (navigationVisibility = .hidden)
                }
            }
        }
    }
}

#Preview {
    ReaderScreen(chapterId: "lkRE7", currentChapterImageId: nil)
}
