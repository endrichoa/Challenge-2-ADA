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
    @State private var navigateToWorkout = false
    @State private var showCountdown = false
    @State private var countdownValue = 3
    @State private var countdownProgress: CGFloat = 1.0
    
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
        .onChange(of: navigateToWorkout) { _, newValue in
            if newValue {
                walkDetectionManager.stopDetection()
            } else {
                walkDetectionManager.startDetection()
            }
        }
        .onChange(of: showCountdown) { _, newValue in
            if newValue {
                runCountdown()
            }
        }
    }
    
    private func runCountdown() {
        WKInterfaceDevice.current().play(.start)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdownValue > 1 {
                countdownValue -= 1
                countdownProgress -= 1.0 / 3.0
                WKInterfaceDevice.current().play(.directionUp)
            } else {
                timer.invalidate()
                showCountdown = false
                navigateToWorkout = true
                showWalkDetection = false
                WKInterfaceDevice.current().play(.success)
                
                // Reset countdown for next time
                countdownValue = 3
                countdownProgress = 1.0
            }
        }
    }
}

#Preview {
    HomeView(path: .constant([]))
}
