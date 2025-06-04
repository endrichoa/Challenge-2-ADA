import SwiftUI

struct EndWorkoutView: View {
    @Binding var path: [Routes]
    
    @State var vm: HomeViewModel
    @ObservedObject var workoutManager: WorkoutManager
    @Binding var selectedTab: Int // Add binding to control tab selection
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
                            // Toggle between pause and resume based on current session state
                            if workoutManager.canPauseWorkout() {
                                workoutManager.pauseWorkout()
                            } else if workoutManager.canResumeWorkout() {
                                workoutManager.resumeWorkout()
                            }
                            // Automatically switch to StartWorkoutView tab
                            selectedTab = 1
                        }) {
                            // Show different images based on workout state
                            // Show pause button if workout can be paused, play button if it can be resumed
                            Image(workoutManager.canPauseWorkout() ? "pausebutton" : "resumebutton")
                                .resizable()
                                .frame(width: buttonSize, height: buttonSize)
                        }
                        .buttonStyle(.plain)
                        .disabled(!workoutManager.canPauseWorkout() && !workoutManager.canResumeWorkout())
                        
                        // Show different text based on workout state
                        Text(workoutManager.canPauseWorkout() ? "Pause" : "Resume")
                            .font(.custom("Dogica", size: 10, relativeTo: .title))
                            .foregroundColor(Color(hex: "#44211B"))
                        
                    }
                    
                    VStack  {
                        Button(action: { path.append(.summary(workoutManager: workoutManager)) }) {
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
    EndWorkoutView(
        path: .constant([.workout]),
        vm: HomeViewModel(),
        workoutManager: WorkoutManager(),
        selectedTab: .constant(0)
    )
}
