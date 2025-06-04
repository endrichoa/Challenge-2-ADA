//
//  PetView.swift
//  virtual-pet Watch App
//
//  Created by Hanna Nadia Savira on 20/05/25.
//

import SwiftUI

struct PetView: View {
    @Binding var path: [Routes]
    @State var vm: HomeViewModel
    @State private var dogFrame = 1
    @State private var dogTimer: Timer? = nil
    @State private var isHappy = false
    @State private var isSad = false
    @State private var happyFrame = 1
    let dogIdleFrameCount = 2
    let dogHappyFrameCount = 6 // Change if you have more happy frames
    let dogSadFrameCount = 3
    let dogAnimationInterval = 0.5
    let dogHappyAnimationInterval = 0.09
    let dogSadAnimationInterval = 0.3
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Steps Progress Bar and Text (positioned at top)
                VStack(spacing: 6) {
                    Button(action: vm.onOpenEditPage) {
                        ProgressBar(
                            progress: vm.progressBarPercentage,text:
                                "\(vm.totalSteps.formatted())/\(vm.dailyTarget.formatted()) STEPS"                      )
                        .frame(height: 8) // Thinner progress bar
                        .frame(maxWidth: geometry.size.width * 0.85) // 85% of screen width
                        .fontWeight(.bold)

                    }
                    .buttonStyle(.plain)
                    
                    
                  
                }
                .padding(.top, 12)
                .padding(.horizontal, 16)
                .offset(y:20)
                
                // Spacer to push dog down
                Spacer()
                    .frame(minHeight: 20, maxHeight: 35)
                
                // Animated dog (centered vertically in remaining space)
                Image(isHappy ? "DogHappy\(happyFrame)" : (isSad ? "DogSad\(dogFrame)" : "DogIdle\(dogFrame)"))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 85, height: 75) // Slightly smaller to match proportions
                    .scaleEffect(x: -1.4, y: 1.4)
                    .onTapGesture {
                        triggerHappyDog()
                        vm.addPetting()
                    }
                    .offset(y:35)
                
                // Spacer to push progress bars down
                Spacer()
                    .frame(minHeight: 25, maxHeight: 40)
                
                // Hunger and Happiness Progress Bars (positioned at bottom)
                HStack(alignment: .bottom, spacing: 55) {
                    Button(action: { path.append(.store) }) {
                        VStack(spacing: 3) {
                            HungerProgressBar(progress: Double(vm.hungerLevel) / 100.0, size: CGSize(width: 25, height: 25))
                            Text("\(vm.hungerLevel)%")
                                .font(.custom("Dogica Pixel", size: 8, relativeTo: .caption))
                                .foregroundStyle(.black)
                                .fontWeight(.bold)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    VStack(spacing: 3) {
                        HeartProgressBar(progress: Double(vm.happinessLevel) / 100.0, size: CGSize(width: 25, height: 25))
                        Text("\(vm.happinessLevel)%")
                            .font(.custom("Dogica Pixel", size: 8, relativeTo: .caption))
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                    }
                }
                .padding(.bottom, 18)
                
                // Small spacer at bottom
                Spacer()
                    .frame(maxHeight: 8)
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("HomeScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        .onAppear {
            startDogAnimation()
            vm.fetchSteps()
            vm.updateSteps()
            checkDogMood()
        }
        .onDisappear {
            stopDogAnimation()
        }
    }
    
    private func startDogAnimation() {
        dogTimer?.invalidate()
        if isHappy {
            dogTimer = Timer.scheduledTimer(withTimeInterval: dogHappyAnimationInterval, repeats: true) { _ in
                happyFrame = happyFrame % dogHappyFrameCount + 1
            }
        } else if isSad {
            dogTimer = Timer.scheduledTimer(withTimeInterval: dogSadAnimationInterval, repeats: true) { _ in
                dogFrame = dogFrame % dogSadFrameCount + 1
            }
        } else {
            dogTimer = Timer.scheduledTimer(withTimeInterval: dogAnimationInterval, repeats: true) { _ in
                dogFrame = dogFrame % dogIdleFrameCount + 1
            }
        }
    }
    
    private func stopDogAnimation() {
        dogTimer?.invalidate()
        dogTimer = nil
    }
    
    private func triggerHappyDog() {
        isHappy = true
        isSad = false
        happyFrame = 1
        stopDogAnimation()
        startDogAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isHappy = false
            checkDogMood()
        }
    }
    
    private func checkDogMood() {
        isSad = vm.happinessLevel < 30
        if isSad {
            dogFrame = 1
        }
        startDogAnimation()
    }
}

#Preview {
    PetView(path: .constant([]), vm: HomeViewModel())
}

