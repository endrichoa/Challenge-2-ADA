////
////  ProgressBar.swift
////  virtual-pet Watch App
////
////  Created by Hanna Nadia Savira on 26/05/25.
////
//
//import SwiftUI
//
//struct ProgressBar: View {
//    var progress: Double
//    let barWidth: CGFloat = 80
//    let barHeight: CGFloat = 16
//    
//    var body: some View {
//        ZStack(alignment: .leading) {
//            // Empty progress bar background
//            Image("ProgressBarEmpty")
//                .resizable()
//                .frame(width: barWidth, height: barHeight)
//            
//            // Filled progress bar
//            Image("ProgressBar")
//                .resizable()
//                .frame(width: barWidth * CGFloat(progress), height: barHeight)
//                .clipped()
//        }
//    }
//}
//
//#Preview {
//    VStack(spacing: 10) {
//        ProgressBar(progress: 1.0)
//        ProgressBar(progress: 0.75)
//        ProgressBar(progress: 0.5)
//        ProgressBar(progress: 0.25)
//        ProgressBar(progress: 0.0)
//    }
//    .background(.white)
//}
//
//  ProgressBar.swift
//  virtual-pet Watch App
//
//  Created by Hanna Nadia Savira on 26/05/25.
//

import SwiftUI

struct ProgressBar: View {
    var progress: Double
    var text: String
    
    var body: some View {
        VStack(spacing: 8) {
            ProgressView(value: progress)
            Text(text)
                .font(.custom("Dogica Pixel", size: 10, relativeTo: .title3))
        }
        .foregroundStyle(.black)
        .tint(.black)
        .padding(.top, 32)
    }
}

#Preview {
    ProgressBar(progress: 0.5, text: "10000/20000 Steps")
        .background(.white)
}
