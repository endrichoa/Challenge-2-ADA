import SwiftUI

struct WorkoutTabView: View {
    @Binding var path: [Routes]
    
    @StateObject private var workoutManager = WorkoutManager()
    @State private var vm = HomeViewModel()
    @State var selectedTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // End Workout Tab
            EndWorkoutView(path: $path, vm: vm, workoutManager: workoutManager, selectedTab: $selectedTab)
                .tag(0)
            
            // Start Workout Tab - PASS THE SAME INSTANCE
            StartWorkoutView(workoutManager: workoutManager)
                .tag(1)
            
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .navigationBarBackButtonHidden()
    }
}
