import SwiftUI

struct HeartProgressBar: View {
    let progress: Double // 0.0 to 1.0
    let size: CGSize
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("LoveProgressBar")
                .resizable()
                .frame(width: size.width, height: size.height)
                .opacity(0.2) // background (empty)
            Image("LoveProgressBar")
                .resizable()
                .frame(width: size.width, height: size.height)
                .mask(
                    VStack {
                        Spacer(minLength: 0)
                        Rectangle()
                            .frame(width: size.width, height: size.height * CGFloat(progress))
                    }
                )
        }
    }
} 