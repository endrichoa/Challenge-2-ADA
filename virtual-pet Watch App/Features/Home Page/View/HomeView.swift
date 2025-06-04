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
    @State private var showCountdown = false
    @State private var countdownValue = 3
    @State private var countdownProgress: CGFloat = 1.0
    
    var body: some View {
        NavigationStack {
            TabView(selection: $viewModel.selectedTab) {
                RecordScreenBeforeView(navigateToWorkout: $navigateToWorkout)
                    .tag(0)
                
                TabView {
                    // Main pet view with improved layout
                    PetView(vm: viewModel)
                        .ignoresSafeArea(.all) // Ensure full screen usage
                    
                    HistoryView(
                        vm: HistoryViewModel(dailyGoal: viewModel.dailyTarget, last7Days: []),
                        dailyGoal: viewModel.dailyTarget
                    )
                }
                .tabViewStyle(.verticalPage)
                .tag(1)
            }
            .tabViewStyle(.page)
            .ignoresSafeArea(.all) // Full screen for TabView
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
            .alert("Are you walking?", isPresented: $showWalkDetection) {
                Button("Start Workout", role: .none) {
                    showCountdown = true
                }
                Button("Not Now", role: .cancel) {}
            } message: {
                Text("Would you like to record this walk?")
            }
            .navigationDestination(isPresented: $navigateToWorkout) {
                WorkoutTabView()
                    .onAppear {
                        walkDetectionManager.stopDetection()
                    }
            }
            
            // Countdown overlay when starting workout
            if showCountdown {
                ZStack {
                    // Blurred background
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .blur(radius: 10)
                    // Animated green ring
                    Circle()
                        .trim(from: 0, to: countdownProgress)
                        .stroke(
                            AngularGradient(gradient: Gradient(colors: [Color.green, Color.green.opacity(0.7)]), center: .center),
                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 120, height: 120)
                        .animation(.linear(duration: 1), value: countdownProgress)
                    // Countdown number
                    Text("\(countdownValue)")
                        .font(.custom("Dogica Pixel", size: 60))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
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
        .onChange(of: showCountdown) { newValue in
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
    HomeView()
}
