//
//  EndWorkoutView.swift
//  virtual-pet
//
//  Created by Shreyas Venadan on 22/5/2025.
//

import SwiftUI

struct EndWorkoutView: View {
    
    @State var vm: HomeViewModel
    @ObservedObject var workoutManager: WorkoutManager
    @State private var navigateSummaryView = false

    // button formatting
    let buttonSize: CGFloat = 80

    
    var body: some View {
        
        ZStack {
            
            
            Image("HomeScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 2)
            
            
            
            VStack(spacing: 20) {
                
                HStack(spacing: 12)  {
                    
                    VStack  {
                        
                        Button(action: {
                            // Toggle between pause and resume based on current state
                            if workoutManager.running {
                                workoutManager.pauseWorkout()
                            } else {
                                workoutManager.resumeWorkout()
                            }
                        }) {
                            // Show different images based on workout state
                            Image(workoutManager.running ? "pausebutton" : "playbutton")
                                .resizable()
                                .frame(width: buttonSize, height: buttonSize)
                        }
                        .buttonStyle(.plain)
                        .disabled(!workoutManager.canPauseWorkout() && !workoutManager.canResumeWorkout())
                        
                        // Show different text based on workout state
                        Text(workoutManager.running ? "Pause" : "Resume")
                            .font(.custom("Dogica", size: 10, relativeTo: .title))
                            .foregroundColor(Color(hex: "#44211B"))
                        
                    }
                    
                    VStack  {
                        NavigationLink(destination: WorkoutSummaryView(workoutManager: workoutManager, vm: vm),
                                       isActive: $navigateSummaryView) {
                            Image("endbutton")
                                .resizable()
                                .frame(width: buttonSize, height: buttonSize)
                        }
                        .buttonStyle(.plain)
                        .simultaneousGesture(TapGesture().onEnded {
                            workoutManager.endWorkout()
                            navigateSummaryView = true
                        })
                        
                        Text("End")
                            .font(.custom("Dogica", size: 10, relativeTo: .title3))
                            .foregroundColor(Color(hex: "#44211B"))
                    }
                    
                }
                
                
                
                Button(action: vm.onOpenEditPage) {
                    VStack(spacing: 8) {
                        ProgressView(value: vm.progressBarPercentage)
                        Text("\(vm.currentSteps.formatted())/\(vm.dailyTarget.formatted()) STEPS")
                            .font(.custom("Dogica", size: 10, relativeTo: .title3))
                            .kerning(-2)
                    }
                }
                .foregroundStyle(Color(hex: "#44211B"))
                .tint(.black)
                .buttonStyle(.plain)
                .padding(.horizontal, 100)
            }
        }
        
    }
    
}


#Preview {
    EndWorkoutView(vm: HomeViewModel(), workoutManager: WorkoutManager())
}
