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
            Spacer()
                .frame(height: 40)
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
            
            Spacer()
                .frame(height: 20)
            
            Image("dogChar")
                .resizable()
                .frame(width: 120, height: 120)
            
            Spacer()
                .frame(height: 20)
            
            HStack(alignment:.bottom, spacing: 40) {
                VStack(alignment: .leading) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 24))
                        .frame(height: 24)
                    Text("\(vm.happinessLevel)%")
                        .font(.caption2)
                }
                .offset(x: -10, y:-20 )

                VStack(alignment: .leading) {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 24))
                        .frame(height: 24)
                    Text("\(vm.hungerLevel)%")
                        .font(.caption2)
                }
                .offset(x: 10, y:-20 )
            }
            .foregroundStyle(.black.opacity(0.8))
            
            Spacer()
                .frame(height: 20)
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
