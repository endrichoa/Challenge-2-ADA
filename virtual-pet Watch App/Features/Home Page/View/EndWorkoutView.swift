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
    @State private var showingSummaryView = false

    // button formatting
    let buttonSize: CGFloat = 80

    
    var body: some View {
        
        ZStack {
            
            Color(hex: "#69CCED")
                .ignoresSafeArea()
            
            VStack {
                
                HStack(spacing: 12)  {
                    
                    VStack  {
                        
                        Button(action:  {
                            workoutManager.pauseWorkout()
                        })  {
                            Image("pausebutton")
                                .resizable()
                                .frame(width: buttonSize, height: buttonSize)
                        }
                        .buttonStyle(.plain)
                        
                        Text("Pause")
                            .font(.custom("Dogica", size: 10, relativeTo: .title))
                            .foregroundColor(Color(hex: "#44211B"))
                        
                    }
                    
                    VStack  {
                        Button(action:  {
                            workoutManager.endWorkout()
                            showingSummaryView = true
                            
                        })  {
                            Image("endbutton")
                                .resizable()
                                .frame(width: buttonSize, height: buttonSize)
                            
                        }
                        .buttonStyle(.plain)
                        Text("End")
                            .font(.custom("Dogica", size: 10, relativeTo: .title3))
                            .foregroundColor(Color(hex: "#44211B"))
                    }
                    
                }
                
                Spacer()
                
                
                VStack {
                    ProgressView(value: vm.progressBarPercentage)
                        .padding(.horizontal, 10)
                        .tint(.black)
                    Spacer().frame(height:7)
                    Text("\(vm.currentSteps.formatted())/\(vm.dailyTarget.formatted()) steps")
                        .font(.custom("Dogica", size: 10, relativeTo: .title3))
                        .foregroundColor(Color(hex: "#44211B"))
                        .kerning(-2)
                }
            }
        }
            
            
        .fullScreenCover(isPresented: $showingSummaryView)  {
            WorkoutSummaryView(workoutManager: workoutManager, vm: vm)
        }
        
        .onChange(of: workoutManager.showingSummaryView) {
            showingSummaryView = workoutManager.showingSummaryView
        }
    
    }
}


#Preview {
    EndWorkoutView(vm: HomeViewModel(), workoutManager: WorkoutManager())
}

