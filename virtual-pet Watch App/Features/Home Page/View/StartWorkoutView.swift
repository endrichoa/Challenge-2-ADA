//
//  StartWorkoutView.swift
//  virtual-pet Watch App
//
//  Created by Hanna Nadia Savira on 20/05/25.
//

import SwiftUI

struct StartWorkoutView: View {
    @StateObject var workoutManager = WorkoutManager()
    
    // Format seconds to HH:mm:ss
    func formatTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, secs)
        } else {
            return String(format: "%02d:%02d", minutes, secs)
        }
    }
    
    // Format distance in km with 2 decimals
    func formatDistance(_ meters: Double) -> String {
        let km = meters / 1000.0
        return String(format: "%.2f", km)
    }
    
    var body: some View {
        ZStack {
            Image("home-background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 8)
                // Steps Count
                Text("\(workoutManager.steps)")
                    .font(.custom("dogica pixel", size: 36))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#1A0F23"))
                    .padding(.bottom, 0)
                // Steps Walked Label
                Text("STEPS WALKED")
                    .font(.custom("dogica pixel", size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#1A0F23"))
                    .padding(.bottom, 8)
                Spacer()
                // Metrics and Dog Row
                HStack(alignment: .center) {
                    // Heart Rate (icon left, value right)
                    VStack(spacing: 2) {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.red)
                        Text("\(Int(workoutManager.heartRate))")
                            .font(.custom("dogica pixel", size: 13))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#1A0F23"))
                    }
                    .frame(width: 40)
                    Spacer(minLength: 0)
                    Image("dogChar")
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 80, height: 45)
                        .padding(.horizontal, 0)
                    Spacer(minLength: 0)
                    VStack(spacing: 2) {
                        Text("\(formatDistance(workoutManager.distance))")
                            .font(.custom("dogica pixel", size: 11))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#1A0F23"))
                        Text("KM")
                            .font(.custom("dogica pixel", size: 10))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#1A0F23"))
                    }
                    .frame(width: 40)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
                Spacer()
                Text(formatTime(workoutManager.elapsedSeconds))
                    .font(.custom("dogica pixel", size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#1A0F23"))
                    .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            workoutManager.requestAuthorization()
            workoutManager.selectedWorkout = .walking
            workoutManager.startWorkout()
        }
    }
}

#Preview {
    StartWorkoutView()
}
