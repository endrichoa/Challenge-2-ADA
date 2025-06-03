import SwiftUI

struct StartWorkoutView: View {
    @ObservedObject var workoutManager: WorkoutManager // CHANGED FROM @StateObject
    @State private var animationOffset: CGFloat = 0
    @State private var cloudAnimationOffset: CGFloat = -100
    @State private var grassAnimationOffset: CGFloat = -300
    
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
            GeometryReader { geometry in
                
                // Static sky background
                Image("SkyBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // Slow-moving clouds - automatically pause/resume based on workout state
                Image("CloudBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 3)
                    .offset(x: cloudAnimationOffset, y: 7)
                    .ignoresSafeArea()
                    .onAppear {
                        startCloudAnimation(geometry: geometry)
                    }
                    .onChange(of: workoutManager.running) { _, isRunning in
                        if isRunning && !workoutManager.isPaused {
                            startCloudAnimation(geometry: geometry)
                        }
                    }
                    .onChange(of: workoutManager.isPaused) { _, isPaused in
                        if !isPaused && workoutManager.running {
                            startCloudAnimation(geometry: geometry)
                        }
                    }
                
                // Fast-moving grass - automatically pause/resume based in workout state
                Image("GrassBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 3)
                    .offset(x: grassAnimationOffset, y: 5)
                    .ignoresSafeArea()
                    .onAppear {
                        startGrassAnimation(geometry: geometry)
                    }
                    .onChange(of: workoutManager.running) { _, isRunning in
                        if isRunning && !workoutManager.isPaused {
                            startGrassAnimation(geometry: geometry)
                        }
                    }
                    .onChange(of: workoutManager.isPaused) { _, isPaused in
                        if !isPaused && workoutManager.running {
                            startGrassAnimation(geometry: geometry)
                        }
                    }
            }
            
            
            // UI Content overlay
            VStack(spacing: 0) {
                Spacer().frame(height: 8)
                // Steps Count
                Text("\(workoutManager.steps)")
                    .font(.custom("dogica pixel", size: 36))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#1A0F23"))
                    .padding(.bottom, 2)
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
                            .foregroundColor(Color(red: 0.22, green: 0.11, blue: 0.09))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Dog character - changes based in workout state
                    Image("dogChar") // You can add pause state later: workoutManager.isPaused ? "dogCharPaused" : "dogChar"
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 91, height: 60)
                        .padding(.horizontal, 8)
                        .opacity(workoutManager.isPaused ? 0.7 : 1.0)
                    
                    VStack(spacing: 4) {
                        Text(formatDistance(workoutManager.distance))
                            .font(.custom("dogica pixel", size: 14))
                            .foregroundColor(Color(hex: "#1A0F23"))
                    }
                    .frame(width: 40)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
                Spacer()
                // Timer - shows elapsed time excluding paused periods
                Text(formatTime(workoutManager.elapsedSeconds))
                    .font(.custom("dogica pixel", size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#1A0F23"))
                    .padding(.bottom, 32)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            // ONLY START WORKOUT IF NOT ALREADY STARTED
            if workoutManager.session == nil {
                workoutManager.requestAuthorization()
                workoutManager.selectedWorkout = .walking
                workoutManager.startWorkout()
            }
        }
    }
    
    // HELPER FUNCTIONS FOR ANIMATION CONTROL
    private func startCloudAnimation(geometry: GeometryProxy) {
        // Only start animation if workout is running and not paused
        guard workoutManager.running && !workoutManager.isPaused else { return }
        withAnimation(.linear(duration: 500).repeatForever(autoreverses: false)) {
            cloudAnimationOffset = -geometry.size.width * 2
        }
    }
    
    private func startGrassAnimation(geometry: GeometryProxy) {
        // Only start animation if workout is running and not paused
        guard workoutManager.running && !workoutManager.isPaused else { return }
        withAnimation(.linear(duration: 75).repeatForever(autoreverses: false)) {
            grassAnimationOffset = -geometry.size.width * 2
        }
    }
}



#Preview {
    StartWorkoutView(workoutManager: WorkoutManager())
}
