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
                .font(.custom("Dogica Pixel", size: 11, relativeTo: .title3))
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
