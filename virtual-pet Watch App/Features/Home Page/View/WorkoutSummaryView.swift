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
     @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        
        ZStack {

            Image("SummaryBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 2)
                
            
            ScrollView {
                
                VStack {
                // Header with exit button
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("exiticon")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                .padding(.horizontal)
                    
                    // Title
                    VStack(spacing: 5) {
                        Text("WALK")
                            .font(.custom("Dogica", size: 18, relativeTo: .title))
                            .foregroundColor(.black)
                        
                        Text("SUMMARY")
                            .font(.custom("Dogica", size: 18, relativeTo: .title))
                            .foregroundColor(.black)
                    }
                    
                    Spacer().frame(height: 15)
                    
                    // Coins gained
                    VStack(spacing: 5) {
                        Text("COINS GAINED")
                            .font(.custom("Dogica", size: 10, relativeTo: .caption))
                            .foregroundColor(.black)
                        
                        HStack(spacing: 8) {
                            Image("coinicon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                            Text("\(workoutManager.coinsEarned)")
                                .font(.custom("Dogica", size: 16, relativeTo: .title2))
                                .foregroundColor(.black)
                        }
                    }
                    
                    Spacer().frame(height: 8)
                    
                    // Total time
                    VStack(spacing: 5) {
                        Text("TOTAL TIME")
                            .font(.custom("Dogica", size: 8, relativeTo: .caption))
                            .foregroundColor(.black)
                        
                        Text(formatDuration(seconds: workoutManager.elapsedSeconds))
                            .font(.custom("Dogica", size: 16, relativeTo: .title2))
                            .foregroundColor(.black)
                            .kerning(-1)
                    }
                    
                    Spacer().frame(height: 15)
                    
                    // Stats grid
                    VStack(spacing: 6) {
                        
                        // Total steps
                        HStack {
                            VStack(alignment: .leading) {
                                Text("TOTAL")
                                    .font(.custom("Dogica", size: 10, relativeTo: .caption2))
                                    .foregroundColor(.black)
                                Text("STEPS")
                                    .font(.custom("Dogica", size: 10, relativeTo: .caption2))
                                    .foregroundColor(.black)
                            }
                            Spacer()

                            
                            Text(workoutManager.totalSteps.formatted())
                                .font(.custom("Dogica", size: 16, relativeTo: .title2))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal)
                        
                        // Distance
                        HStack {
                            Text("DISTANCE")
                                .font(.custom("Dogica", size: 10, relativeTo: .caption2))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Text(String(format: "%.2f", workoutManager.totalDistanceInKM))
                                    .font(.custom("Dogica", size: 16, relativeTo: .title2))
                                    .foregroundColor(.black)
                                
                                Text("KM")
                                    .font(.custom("Dogica", size: 10, relativeTo: .caption2))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Average heart rate
                        HStack {
                            VStack(alignment: .leading) {
                                Text("AVERAGE")
                                    .font(.custom("Dogica", size: 10, relativeTo: .caption2))
                                    .foregroundColor(.black)
                                Text("HEART RATE")
                                    .font(.custom("Dogica", size: 10, relativeTo: .caption2))
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Text("\(Int(workoutManager.averageHeartRate))")
                                    .font(.custom("Dogica", size: 16, relativeTo: .title2))
                                    .foregroundColor(.black)
                                
                                Text("BPM")
                                    .font(.custom("Dogica", size: 10, relativeTo: .caption2))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
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
