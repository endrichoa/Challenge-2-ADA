//
//  recordScreenBefore.swift
//  virtual-pet Watch App
//
//  Created by Endricho Abednego on 21/05/25.
//


import SwiftUI
import WatchKit

struct RecordScreenBeforeView: View {
    @Binding var path: [Routes]
    
    @State private var viewModel = HomeViewModel()
    @State private var progress: Double = 0.65
    @State private var showCountdown = false
    @State private var countdownValue = 3
    @State private var countdownProgress: CGFloat = 1.0
    @State private var showWalkDetection = false
    @State private var walkDetectionManager = WalkDetectionManager()
    @State private var dogFrame = 1
    @State private var dogTimer: Timer? = nil
    let dogIdleFrameCount = 2
    let dogAnimationInterval = 0.5
    
    var body: some View {
        ZStack {
            Image("home-background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer().frame(height: 24)
                Text("READY TO WALK?")
                    .font(.custom("dogica pixel", size: 16))
                    .fontWeight(.bold)
                    .kerning(-3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#1A0F23"))
                    .padding(.bottom, 6)
                    .padding(.horizontal, 8)
                Text("TOUCH TO RECORD")
                    .font(.custom("dogica", size: 14))
                    .fontWeight(.bold)
                    .kerning(-2)
                    .foregroundColor(Color(hex: "#1A0F23"))
                    .padding(.bottom, 18)
                    .padding(.horizontal, 8)
                Spacer()
                Image("DogIdle\(dogFrame)")
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 90, height: 45)
                    .padding(.bottom, 24)
                    .scaleEffect(x: -1.6, y: 1.6)

                let stepsRemaining = viewModel.dailyTarget - viewModel.totalSteps
                Text(stepsRemaining > 0 ? "\(stepsRemaining) STEPS REMAINING" : "COMPLETED")
                    .font(.custom("dogica", size: 10))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundColor(Color(hex: "#1A0F23"))
                    .padding(.bottom, 8)
                    .padding(.horizontal, 8)
                    .kerning(-2)
                VStack(spacing: 8) {
                    ProgressView(value: viewModel.progressBarPercentage)
                }
                .foregroundStyle(.black)
                .tint(.black)
                .buttonStyle(.plain)
                .padding(.bottom, 4)
                .padding(.horizontal, 8)
            
                    
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                showCountdown = true
                startCountdown()
            }
            // Walk detection
            .alert("Are you walking?", isPresented: $showWalkDetection) {
                Button("Start Workout", role: .none) {
                    startCountdown()
                    path.append(.workout)
                }
                Button("Not Now", role: .cancel) {}
            } message: {
                Text("Would you like to record this walk?")
            }
            // Countdown overlay
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
        .onAppear {
            walkDetectionManager.onWalkDetected = {
                showWalkDetection = true
            }
            walkDetectionManager.startDetection()
            viewModel.fetchSteps()
            viewModel.updateSteps()
            startDogAnimation()
        }
        .onDisappear {
            walkDetectionManager.stopDetection()
            stopDogAnimation()
        }
        .onChange(of: showCountdown) { _, newValue in
            if newValue {
                runCountdown()
            }
        }
    }
    
    private func startCountdown() {
        countdownValue = 3
        countdownProgress = 1.0
        showCountdown = true
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
                showWalkDetection = false
                path.append(.workout)
                WKInterfaceDevice.current().play(.success)
            }
        }
    }
    
    private func startDogAnimation() {
        dogTimer?.invalidate()
        dogTimer = Timer.scheduledTimer(withTimeInterval: dogAnimationInterval, repeats: true) { _ in
            dogFrame = dogFrame % dogIdleFrameCount + 1
        }
    }
    
    private func stopDogAnimation() {
        dogTimer?.invalidate()
        dogTimer = nil
    }
}

struct StatusBar: View {
    let value: Double
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.system(size: 15))
            ProgressView(value: value)
                .progressViewStyle(LinearProgressViewStyle())
                .frame(height: 4)
        }
        .position(x: 45, y: 130)
    }
}

struct ActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: systemImage)
                    .font(.system(size: 16))
                Text(title)
                    .font(.system(size: 10))
            }
            .padding(4)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
        }
    }
}




#Preview {
    RecordScreenBeforeView(path: .constant([]))
}
