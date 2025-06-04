//
//  HomeView.swift
//  virtual-pet Watch App
//
//  Created by Hanna Nadia Savira on 19/05/25.
//

import SwiftUI
import WatchKit

struct HomeView: View {
    @Binding var path: [Routes]
    
    @State private var viewModel = HomeViewModel()
    @StateObject private var walkDetectionManager = WalkDetectionManager()
    @State private var showWalkDetection = false
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            RecordScreenBeforeView(path: $path)
                .tag(0)
            TabView {
                PetView(path: $path, vm: viewModel)
                HistoryView(vm: HistoryViewModel(dailyGoal: viewModel.dailyTarget, last7Days: []), dailyGoal: viewModel.dailyTarget)
            }
            .tabViewStyle(.verticalPage)
            .tag(1)
        }
        .tabViewStyle(.page)
        .onAppear() {
            viewModel.fetchSteps()
            viewModel.updateSteps()
            walkDetectionManager.startDetection()
        }
        .navigationDestination(isPresented: $viewModel.openEditPage) {
            EditTargetView(vm: viewModel)
        }
        .confirmationDialog("Start your walk?", isPresented: $showWalkDetection) {
            Button("Start", role: .none) {
                walkDetectionManager.stopDetection()
                path.append(.workout)
            }
            Button("Cancel", role: .cancel) {}
        }
        .fontWeight(.bold)
        .onAppear {
            walkDetectionManager.onWalkDetected = {
                WKInterfaceDevice.current().play(.notification)
                showWalkDetection = true
            }
            walkDetectionManager.startDetection()
        }
        .onDisappear {
            walkDetectionManager.stopDetection()
        }
    }
}

#Preview {
    HomeView(path: .constant([]))
}
