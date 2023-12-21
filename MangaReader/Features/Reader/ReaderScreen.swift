//

import SwiftUI

struct ReaderScreen: View {
    @StateObject var viewModel = ReaderScreenViewModel()
    
    let chapterId: String
    var dismiss: (() -> Void)?
        
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                
            }
            .frame(width: geometry.size.width)
            .background(.black)
        }
    }
}

#Preview {
    ReaderScreen(chapterId: "")
}
