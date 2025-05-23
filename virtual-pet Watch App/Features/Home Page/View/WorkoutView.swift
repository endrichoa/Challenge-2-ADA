//
//  WorkoutView.swift
//  virtual-pet
//
//  Created by Shreyas Venadan on 22/5/2025.
//


//
//  WorkoutTabView.swift
//  virtual-pet Watch App
//
//  Created on 22/05/25.
//

import SwiftUI

struct WorkoutTabView: View {
    @StateObject private var workoutManager = WorkoutManager()
    @State private var vm = HomeViewModel()
    @State var selectedTab: Int = 1

    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // End Workout Tab
            EndWorkoutView(vm: vm, workoutManager: workoutManager)
                .tag(0)
            
            // Start Workout Tab
            StartWorkoutView(workoutManager: workoutManager)
                .tag(1)
            
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}

#Preview {
    WorkoutTabView()
}
