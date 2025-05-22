//
//  ShopItemView.swift
//  virtual-pet
//
//  Created by Hanna Nadia Savira on 20/05/25.
//

import SwiftUI

struct ShopItemView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            Text("Shop")
            LazyVGrid(columns: columns) {
                ForEach(0..<10) { index in
                    VStack {
                        Image(systemName: "heart.fill")
                        Text("Item #\(index + 1)")
                            .lineLimit(1)
                    }
                }
            }
        }
    }
}

#Preview {
    ShopItemView()
}
