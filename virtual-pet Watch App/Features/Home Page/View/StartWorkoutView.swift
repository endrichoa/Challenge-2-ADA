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
        return String(format: "%.2f KM", km)
    }
    
    var body: some View {
        ZStack {
            Image("home-background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: -20)
                // Steps Count
                Text("\(workoutManager.steps)")
                    .font(.custom("dogica pixel", size: 32))
                    .foregroundColor(Color(hex: "#1A0F23"))

                    .padding(.bottom, 2)
                // Steps Walked Label
                Text("STEPS WALKED")
                    .font(.custom("dogica pixel", size: 18))
                    .foregroundColor(Color(hex: "#1A0F23"))

                    .padding(.bottom, 8)
                Spacer()
                // Metrics and Dog Row
                HStack(alignment: .bottom) {
                    // Heart Rate (icon above, value below)
                    VStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                        Text("\(Int(workoutManager.heartRate))")
                            .font(.custom("dogica pixel", size: 14))
                            .fontWeight(.bold)

                            .foregroundColor(Color(red: 0.22, green: 0.11, blue: 0.09))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    Image("dogChar")
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 91, height: 60)
                        .padding(.horizontal, 8)
                    VStack(spacing: 4) {
                        Text(formatDistance(workoutManager.distance))
                            .font(.custom("dogica pixel", size: 14))
                            .foregroundColor(Color(hex: "#1A0F23"))

                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                Spacer()
                // Timer
                Text(formatTime(workoutManager.elapsedSeconds))
                    .font(.custom("dogica pixel", size: 32))
                    .foregroundColor(Color(hex: "#1A0F23"))
                    .padding(.bottom, 32)

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
