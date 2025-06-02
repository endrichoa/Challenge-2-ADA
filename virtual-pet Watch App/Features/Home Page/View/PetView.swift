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
        VStack {
            Button(action: vm.onOpenEditPage) {
                ProgressBar(
                    progress: vm.progressBarPercentage,
                    text: "\(vm.totalSteps.formatted())/\(vm.dailyTarget.formatted()) STEPS"
                )
            }
            .buttonStyle(.plain)
            Spacer()
            Image("dogChar")
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 90, height: 45)
                .scaleEffect(x: -1, y: 1)
                .padding(.bottom, 20)
            HStack(alignment:.bottom, spacing: 52) {
                NavigationLink(destination: StoreView()) {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 24))
                            .frame(height: 24)
                        Text("\(vm.hungerLevel)%")
                    }
                }
                .buttonStyle(.plain)
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 24))
                        .frame(height: 24)
                    Text("\(vm.happinessLevel)%")
                }
            }
            .font(.custom("Dogica Pixel", size: 10, relativeTo: .caption))
            .foregroundStyle(.black)
            .padding(.bottom, 32)
        }
        .ignoresSafeArea()
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 8)
        .background(
            Image("HomeScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    PetView(vm: HomeViewModel())
}
