//
//  ShopItemView.swift
//  virtual-pet
//
//  Created by Hanna Nadia Savira on 20/05/25.
//

import SwiftUI

struct StoreView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var storeVM: StoreViewModel
    let homeVM: HomeViewModel
    
    init(homeVM: HomeViewModel) {
        self.homeVM = homeVM
        let vm = StoreViewModel()
        vm.homeVM = homeVM
        _storeVM = State(initialValue: vm)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .trailing, spacing: 8) {
                HStack {
                    Text("STORE")
                        .font(.custom("Dogica Pixel", size: 18, relativeTo: .headline))
                        .fontWeight(.bold)
                    Spacer()
                    ZStack(alignment: .bottomLeading) {
                        ZStack {
                            Image("coin-placeholder")
                                .resizable()
                                .frame(width: 72, height: 24)
                            Text("\(storeVM.coins)")
                                .font(.custom("Dogica Pixel", size: 10, relativeTo: .caption))
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .padding(.leading, 16)
                        }
                        Image("Coin")
                            .resizable()
                            .frame(width: 26, height: 26)
                    }
                }
                .padding(.horizontal, 16)
                VStack {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(storeVM.items) { item in
                            NavigationLink(
                                destination: BuyItemView(
                                    vm: storeVM,
                                    item: item
                                )
                            ) {
                                VStack(spacing: 8) {
                                    Image("\(item.image)")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    Text("\(item.name.uppercased())")
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                        .frame(height: 24)
                                    HStack(spacing: 8) {
                                        Image("Coin")
                                        Text("\(item.price)")
                                    }
                                }
                            }
                            .foregroundStyle(.black)
                            .font(.custom("Dogica Pixel", size: 10, relativeTo: .caption))
                            .fontWeight(.bold)
                            .lineSpacing(5/4)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity)
                            .background(
                                Image("store-card")
                                    .resizable()
                                    .frame(width: 88, height: 120)
                            )
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .background(
            Image("HistoryScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    StoreView(homeVM: HomeViewModel())
}
