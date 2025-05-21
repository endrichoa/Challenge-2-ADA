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
                    ProgressView(value: vm.progressBar)
                    Text("\(vm.currentSteps.formatted())/\(vm.dailyStepsGoal.formatted()) steps")
                        .font(.title3)
                }
            }
            .buttonStyle(.plain)
            .padding(.top, 32)
            Circle()
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
            .padding(.bottom, 16)
        }
        .ignoresSafeArea()
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationDestination(isPresented: $vm.openEditPage) {
            EditTargetView(vm: vm)
        }
    }
}

#Preview {
    PetView(vm: HomeViewModel())
}
