//
//  BuyItemView.swift
//  virtual-pet Watch App
//
//  Created by Hanna Nadia Savira on 28/05/25.
//

import SwiftUI

struct BuyItemView: View {
    @Environment(\.dismiss) var dismiss
    @State var vm: StoreViewModel
    let item: StoreItemModel
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(item.name.uppercased())")
            Image("\(item.image)")
                .resizable()
                .frame(width: 80, height: 80)
                .scaledToFit()
            Text("Food Points: 40")
                .font(.custom("Dogica Pixel", size: 10, relativeTo: .caption))
                .fontWeight(.bold)
            Spacer()
            Button(
                action: {
                    vm.buyItem(item)
                    dismiss()
                }
            ) {
                HStack {
                    Text("BUY")
                    Image("coin")
                    Text("\(item.price)")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 12)
        .background(
            Image("HistoryScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    BuyItemView(vm: StoreViewModel(), item: StoreItemModel.items[0])
}
