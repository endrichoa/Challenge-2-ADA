//
//  ContentView.swift
//  virtual-pet Watch App
//
//  Created by Hanna Nadia Savira on 03/06/25.
//

import SwiftUI

struct ContentView: View {
    @State private var path: [Routes] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            HomeView(path: $path)
                .navigationDestination(for: Routes.self) { route in
                    switch route {
                    case .workout:
                        WorkoutTabView(path: $path)
                    case .store:
                        StoreView(path: $path)
                    case .summary(let workoutManager):
                        WorkoutSummaryView(path: $path, workoutManager: workoutManager)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
