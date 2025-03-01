import Kingfisher
import Models
import Styles
import SwiftData
import SwiftUI

public struct ReaderScreen: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @StateObject private var viewModel = ReaderScreenViewModel()
    @State private var navigationVisibility = Visibility.hidden
    @State private var didInitiateScrollTo = false

    @Environment(\.modelContext) private var modelContext
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

    private var customNavigationView: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .padding(16)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        dismiss?()
                    }
                Spacer()
                Text(viewModel.readerTitle)
                Spacer()
            }
            .background {
                #if os(macOS)
                    BlurView(material: .toolTip, blendingMode: .withinWindow)
                #endif
            }
            Spacer()
        }
        .ignoresSafeArea()
    }

    public var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { reader in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            ForEach(Array(viewModel.images.enumerated()), id: \.offset) { index, image in
                                if let downloadURL = image.url {
                                    VStack {
                                        KFImage(downloadURL)
                                            .startLoadingBeforeViewAppear()
                                            .onFailure { error in
                                                print(error)
                                            }
                                            .placeholder { _ in
                                                Image(systemName: "arrow.circlepath")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(maxWidth: CGFloat(image.width), maxHeight: CGFloat(image.height))
                                            }
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: CGFloat(image.width), maxHeight: CGFloat(image.height))
                                    }
                                    .id(downloadURL.absoluteString)
                                    .onAppear {
                                        if !viewModel.isLoading, !viewModel.images.isEmpty, !didInitiateScrollTo {
                                            reader.scrollTo(currentChapterImageId, anchor: .top)
                                            didInitiateScrollTo = downloadURL.absoluteString == currentChapterImageId
                                        }
                                    }
                                    .task {
                                        guard !viewModel.isLoading, let mangaSlug = image.mangaSlug else { return }

                                        let mangaReadState = mangaReadStates.first { $0.mangaSlug == mangaSlug } ?? MangaReadState(mangaSlug: mangaSlug)
                                        let editedMangaReadState = viewModel.editMangaReadState(currentMangaReadState: mangaReadState,
                                                                                                chapterImageId: downloadURL.absoluteString)
                                        modelContext.insert(editedMangaReadState)
                                        logger.debug("Edited MangaReadState \(editedMangaReadState.mangaSlug ?? "") \(String(editedMangaReadState.chapterNumber ?? 0))")

                                        guard let nextChapter = viewModel.chapterDetailViewModel?.next?.hid, (viewModel.images.endIndex - 1) == index else { return }
                                        await viewModel.getChapterDetail(chapterId: nextChapter)
                                    }
                                }
                            }
                        }
                    }
                    .frame(minHeight: geometry.size.height)
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .toolbar(navigationVisibility)
                .animation(.easeInOut(duration: 0.1), value: navigationVisibility)
                .frame(width: geometry.size.width)
                .background {
                    Color.black
                        .ignoresSafeArea()
                }
                .task {
                    await viewModel.getChapterDetail(chapterId: chapterId)
                }
                .overlay(safeAreaBackground(geometry: geometry))
                #if os(macOS)
                    .overlay {
                        customNavigationView
                    }
                #else
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
                        .onTapGesture {
                            withAnimation {
                                navigationVisibility == .hidden ? (navigationVisibility = .visible) : (navigationVisibility = .hidden)
                            }
                        }
                #endif
            }
        }
    }
}

#Preview {
    ReaderScreen(chapterId: "lkRE7", currentChapterImageId: nil)
}
