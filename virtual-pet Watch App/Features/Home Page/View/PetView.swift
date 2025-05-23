//
//  PetView.swift
//  virtual-pet Watch App
//
//  Created by Hanna Nadia Savira on 20/05/25.
//

import SwiftUI

struct PetView: View {
    @State var vm: HomeViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: vm.onOpenEditPage) {
                VStack(spacing: 8) {
                    ProgressView(value: vm.progressBarPercentage)
                    Text("\(vm.totalSteps.formatted())/\(vm.dailyTarget.formatted()) STEPS")
                        .font(.custom("Dogica Pixel", size: 11, relativeTo: .title3))
                }
            }
            .foregroundStyle(.black)
            .tint(.black)
            .buttonStyle(.plain)
            .padding(.top, 32)
            Image("dog")
            HStack(alignment:.bottom, spacing: 40) {
                NavigationLink(destination: ShopItemView()) {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 24))
                            .frame(height: 24)
                        Text("\(vm.happinessLevel)%")
                    }
                }
                .buttonStyle(.plain)
                NavigationLink(destination: ShopItemView()) {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 24))
                            .frame(height: 24)
                        Text("\(vm.hungerLevel)%")
                    }
                }
                .buttonStyle(.plain)
            }
            .font(.custom("Dogica Pixel", size: 10, relativeTo: .caption))
            .foregroundStyle(.black)
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 8)
        .background(
            Image("home-background")
                .resizable()
                .scaledToFill()
        )
        .ignoresSafeArea(.all)
    }
}

#Preview {
    PetView(vm: HomeViewModel())
}
