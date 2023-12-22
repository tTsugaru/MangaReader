import Kingfisher
import SwiftUI

struct ReaderScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @StateObject var viewModel = ReaderScreenViewModel()
    @State private var navigationVisibility: Visibility = .hidden

    let chapterId: String
    var dismiss: (() -> Void)?

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
                if let title = viewModel.chapterDetailViewModel?.chapter.title {
                    Text(title)
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
            ScrollViewReader { _ in
                ScrollView {
                    HStack {
                        Spacer()
                        LazyVStack(spacing: 0) {
                            if viewModel.isLoading {
                                ProgressView()
                            } else {
                                ForEach(Array(viewModel.images.enumerated()), id: \.offset) { index, image in
                                    if let downloadURL = URL(string: image.url) {
                                        KFImage(downloadURL)
                                            .startLoadingBeforeViewAppear()
                                            .onFailure { error in
                                                print(error)
                                            }
                                            .placeholder {
                                                VStack {
                                                    Text("Loading Chapter Image")
                                                    ProgressView()
                                                }
                                            }
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: CGFloat(image.w))
                                            .onAppear {
                                                guard let nextChapter = viewModel.chapterDetailViewModel?.next?.hid, (viewModel.images.endIndex - 1) == index else { return }
                                                Task {
                                                    await viewModel.getChapterDetail(chapterId: nextChapter)
                                                }
                                            }
                                            .id(image.url)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .frame(minHeight: geometry.size.height)
                }
                .onTapGesture {
                    withAnimation {
                        navigationVisibility == .hidden ? (navigationVisibility = .visible) : (navigationVisibility = .hidden)
                    }
                }
                .scrollIndicators(.hidden)
                .toolbar(navigationVisibility)
                .toolbar(.hidden, for: .tabBar)
                .animation(.easeInOut(duration: 0.1), value: navigationVisibility)
                .frame(width: geometry.size.width)
                .background {
                    withAnimation {
                        if viewModel.isLoading {
                            Color("background", bundle: Bundle.main)
                                .ignoresSafeArea()
                        } else {
                            Color.black
                                .ignoresSafeArea()
                        }
                    }
                }
                .task {
                    await viewModel.getChapterDetail(chapterId: chapterId)
                }
                .navigationTitle(viewModel.chapterDetailViewModel?.chapTitle ?? "")
                .overlay(safeAreaBackground(geometry: geometry))
                #if os(macOS)
                    .overlay {
                        customNavigationView
                    }
                #endif
            }
        }
    }
}

#Preview {
    ReaderScreen(chapterId: "lkRE7")
}
