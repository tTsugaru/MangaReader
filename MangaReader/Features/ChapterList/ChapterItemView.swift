import SwiftUI

struct ChapterItemView: View {
    @ObservedObject var chapterItem: ChapterListItem

    var isFirst = false
    var isLast = false

    var onChapterSelect: ((ChapterListItem) -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 30)
                .foregroundColor(Color.black.opacity(0.1))
                .clipShape(
                    .rect(cornerRadii: RectangleCornerRadii(topLeading: isFirst ? 10 : 0,
                                                            bottomLeading: isLast ? 10 : 0,
                                                            bottomTrailing: isLast ? 10 : 0,
                                                            topTrailing: isFirst ? 10 : 0)
                    )
                )
                .overlay {
                    HStack {
                        Text(chapterItem.title)
                        Spacer()
                        if !(chapterItem.children?.isEmpty ?? true) {
                            Image(systemName: "chevron.down")
                                .rotationEffect(chapterItem.showChildren ? Angle(degrees: -180) : Angle(degrees: 0))
                                .animation(.bouncy(duration: 0.25, extraBounce: 0.2), value: chapterItem.showChildren)
                        }
                    }
                    .padding(.horizontal, 16)
                    .zIndex(1)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    guard !(chapterItem.children?.isEmpty ?? true) else { return }
                    chapterItem.showChildren.toggle()
                }

            if let children = chapterItem.children {
                HStack {
                    if chapterItem.showChildren {
                        VStack(alignment: .leading) {
                            ForEach(children) { child in
                                Text(child.title)
                            }
                        }
                        .transition(.move(edge: .top))
                    }
                    Spacer()
                }
                .clipped()
                .padding(.bottom, chapterItem.showChildren ? 8 : 0)
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 0) {
            ChapterItemView(chapterItem: ChapterListItem(id: "1", title: "Parent 1", children: [
                ChapterListItem(id: "1", title: "1"),
                ChapterListItem(id: "2", title: "2"),
                ChapterListItem(id: "3", title: "3"),
                ChapterListItem(id: "4", title: "4"),
                ChapterListItem(id: "5", title: "5")
            ]), isFirst: true)
            ChapterItemView(chapterItem: ChapterListItem(id: "2", title: "Parent 2", children: [
                ChapterListItem(id: "1", title: "1"),
                ChapterListItem(id: "2", title: "2"),
                ChapterListItem(id: "3", title: "3"),
                ChapterListItem(id: "4", title: "4"),
                ChapterListItem(id: "5", title: "5")
            ]))
            ChapterItemView(chapterItem: ChapterListItem(id: "3", title: "Parent 3", children: [
                ChapterListItem(id: "1", title: "1"),
                ChapterListItem(id: "2", title: "2"),
                ChapterListItem(id: "3", title: "3"),
                ChapterListItem(id: "4", title: "4"),
                ChapterListItem(id: "5", title: "5")
            ]), isLast: true)
        }
        .padding()
    }
}
