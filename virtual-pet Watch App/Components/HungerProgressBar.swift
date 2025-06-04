import SwiftUI

struct HungerProgressBar: View {
    let progress: Double // 0.0 to 1.0
    let size: CGSize
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("HungerProgressBar")
                .resizable()
                .frame(width: size.width, height: size.height)
                .opacity(0.2)
            Image("HungerProgressBar")
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
