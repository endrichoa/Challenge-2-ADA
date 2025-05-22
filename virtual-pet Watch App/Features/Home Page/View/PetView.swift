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
                VStack {
                    ProgressView(value: vm.progressBarPercentage)
                    Text("\(vm.currentSteps.formatted())/\(vm.dailyTarget.formatted()) steps")
                        .font(.custom("Dogica", size: 12, relativeTo: .title3))
                        .kerning(-2)
                }
            }
            .foregroundStyle(.black)
            .tint(.brown)
            .buttonStyle(.plain)
            .padding(.top, 32)
            Image("dog")
            HStack(alignment:.bottom, spacing: 40) {
                VStack(alignment: .leading) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 24))
                        .frame(height: 24)
                    Text("\(vm.happinessLevel)%")
                        .font(.caption2)
                }
                VStack(alignment: .leading) {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 24))
                        .frame(height: 24)
                    Text("\(vm.hungerLevel)%")
                        .font(.caption2)
                }
            }
            .foregroundStyle(.black.opacity(0.8))
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 8)
        .background(
            Image("home-background")
                .resizable()
                .scaledToFill()
        )
        .ignoresSafeArea(.all)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PetView(vm: HomeViewModel())
}
