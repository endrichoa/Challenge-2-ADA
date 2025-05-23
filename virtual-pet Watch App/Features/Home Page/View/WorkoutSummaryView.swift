//
//  WorkoutSummaryView.swift
//  virtual-pet
//
//  Created by Shreyas Venadan on 22/5/2025.
//

import SwiftUI

struct WorkoutSummaryView: View {
    @ObservedObject var workoutManager: WorkoutManager
    @State var vm: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(hex: "#69CCED")
                .ignoresSafeArea()
            
            VStack(spacing: 5) {
                
                // Title - much smaller
                VStack(spacing: 2) {
                    Text("WALK")
                        .font(.custom("Dogica", size: 12))
                        .foregroundColor(Color(hex: "#44211B"))
                    
                    Text("SUMMARY")
                        .font(.custom("Dogica", size: 12))
                        .foregroundColor(Color(hex: "#44211B"))
                }
                .padding(.bottom, 8)
                
                // Total Time - more compact
                VStack(spacing: 3) {
                    Text("TOTAL TIME")
                        .font(.custom("Dogica", size: 8))
                        .foregroundColor(Color(hex: "#44211B"))
                    
                    Text(formatDuration(seconds: workoutManager.elapsedSeconds))
                        .font(.custom("Dogica", size: 16))
                        .foregroundColor(Color(hex: "#44211B"))
                }
                .padding(.bottom, 10)
                
                // Metrics in compact rows
                VStack(spacing: 8) {
                    // Total Steps
                    HStack {
                        Text("TOTAL")
                            .font(.custom("Dogica", size: 6))
                            .foregroundColor(Color(hex: "#44211B"))
                            .frame(width: 45, alignment: .leading)
                        
                        Text("\(workoutManager.totalSteps)")
                            .font(.custom("Dogica", size: 12))
                            .foregroundColor(Color(hex: "#44211B"))
                        
                        Text("STEPS")
                            .font(.custom("Dogica", size: 6))
                            .foregroundColor(Color(hex: "#44211B"))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal, 15)
                    
                    Text("STEPS")  // Second line for "TOTAL STEPS"
                        .font(.custom("Dogica", size: 6))
                        .foregroundColor(Color(hex: "#44211B"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 15)
                        .offset(y: -8)
                    
                    // Distance
                    HStack {
                        Text("DISTANCE")
                            .font(.custom("Dogica", size: 6))
                            .foregroundColor(Color(hex: "#44211B"))
                            .frame(width: 60, alignment: .leading)
                        
                        Spacer()
                        
                        Text(String(format: "%.2f", workoutManager.totalDistance / 1000))
                            .font(.custom("Dogica", size: 12))
                            .foregroundColor(Color(hex: "#44211B"))
                        
                        Text("KM")
                            .font(.custom("Dogica", size: 6))
                            .foregroundColor(Color(hex: "#44211B"))
                            .frame(width: 20, alignment: .trailing)
                    }
                    .padding(.horizontal, 15)
                    
                    // Average Heart Rate
                    HStack {
                        VStack(alignment: .leading, spacing: 1) {
                            Text("AVERAGE")
                                .font(.custom("Dogica", size: 6))
                                .foregroundColor(Color(hex: "#44211B"))
                            Text("HEART RATE")
                                .font(.custom("Dogica", size: 6))
                                .foregroundColor(Color(hex: "#44211B"))
                        }
                        .frame(width: 60, alignment: .leading)
                        
                        Spacer()
                        
                        Text("\(Int(workoutManager.averageHeartRate))")
                            .font(.custom("Dogica", size: 12))
                            .foregroundColor(Color(hex: "#44211B"))
                        
                        Text("BPM")
                            .font(.custom("Dogica", size: 6))
                            .foregroundColor(Color(hex: "#44211B"))
                            .frame(width: 25, alignment: .trailing)
                    }
                    .padding(.horizontal, 15)
                }
                
                Spacer()
                
                // Page indicator dots - smaller
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 6, height: 6)
                    
                    Circle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 6, height: 6)
                }
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 8)
            .onAppear {
                vm.addSteps(workoutManager.totalSteps)
            }
        }
    }
    
    // Format duration from seconds to HH:MM:SS or MM:SS for shorter workouts
    private func formatDuration(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, secs)
        } else {
            return String(format: "%02d:%02d", minutes, secs)
        }
    }
}


#Preview {
    
    
//    WorkoutSummaryView(workoutManager: workoutManager, vm: HomeViewModel())
    
    // Sample data for preview
    let workoutManager = WorkoutManager()
    workoutManager.elapsedSeconds = 2225 // 37:05
    workoutManager.totalSteps = 6735
    workoutManager.totalDistance = 2540 // 2.54 km
    workoutManager.averageHeartRate = 104
    
    return WorkoutSummaryView(workoutManager: workoutManager, vm: HomeViewModel())
    
}
