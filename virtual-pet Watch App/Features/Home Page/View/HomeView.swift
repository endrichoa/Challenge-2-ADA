//
//  HomeView.swift
//  virtual-pet Watch App
//
//  Created by Hanna Nadia Savira on 19/05/25.
//

import SwiftUI
import WatchKit

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @StateObject private var walkDetectionManager = WalkDetectionManager()
    @State private var showWalkDetection = false
    @State private var navigateToWorkout = false
    
    var body: some View {
        NavigationStack {
            TabView(selection: $viewModel.selectedTab) {
                RecordScreenBeforeView(navigateToWorkout: $navigateToWorkout)
                    .tag(0)
                TabView {
                    PetView(vm: viewModel)
                    HistoryView(vm: HistoryViewModel(dailyGoal: viewModel.dailyTarget, last7Days: []), dailyGoal: viewModel.dailyTarget)
                }
                .tabViewStyle(.verticalPage)
                .tag(1)
            }
            .tabViewStyle(.page)
            .onAppear() {
                viewModel.fetchSteps()
                viewModel.updateSteps()
                if !navigateToWorkout {
                    walkDetectionManager.startDetection()
                }
            }
            .navigationDestination(isPresented: $viewModel.openEditPage) {
                EditTargetView(vm: viewModel)
            }
            .confirmationDialog("Start your walk?", isPresented: $showWalkDetection) {
                Button("Start", role: .none) {
                    navigateToWorkout = true
                }
                Button("Cancel", role: .cancel) {}
            }
            .navigationDestination(isPresented: $navigateToWorkout) {
                WorkoutTabView()
                    .onAppear {
                        walkDetectionManager.stopDetection()
                    }
            }
        }
        .fontWeight(.bold)
        .onAppear {
            walkDetectionManager.onWalkDetected = {
                WKInterfaceDevice.current().play(.notification)
                showWalkDetection = true
            }
            if !navigateToWorkout {
                walkDetectionManager.startDetection()
            }
        }
        .onDisappear {
            walkDetectionManager.stopDetection()
        }
        .onChange(of: navigateToWorkout) { newValue in
            if newValue {
                walkDetectionManager.stopDetection()
            } else {
                walkDetectionManager.startDetection()
            }
        }
    }
}

#Preview {
    HomeView()
}
