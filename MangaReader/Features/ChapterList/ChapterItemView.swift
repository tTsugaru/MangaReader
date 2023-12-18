import SwiftUI

struct ChapterItemView: View {
    @ObservedObject var chapterItem: ChapterListItem

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 10)
                .shadow(color: Color.black, radius: 4)
                .foregroundColor(Color.black.opacity(0.1))
                .frame(height: 30)
                .zIndex(0)
                .overlay {
                    HStack {
                        Text(chapterItem.title)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .rotationEffect(chapterItem.showChildren ? Angle(degrees: -180) : Angle(degrees: 0))
                            .animation(.bouncy(duration: 0.25, extraBounce: 0.2), value: chapterItem.showChildren)
                    }
                    .padding(.horizontal, 16)
                    .zIndex(1)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    chapterItem.showChildren.toggle()
                }

            if let children = chapterItem.children {
                HStack {
                    if chapterItem.showChildren {
                        VStack {
                            ForEach(children) { child in
                                Text(child.title)
                            }
                        }
                        .padding(.horizontal, 32)
                        .transition(.move(edge: .top))
                    }
                    Spacer()
                }
                .clipped()
            }
        }
    }
}
