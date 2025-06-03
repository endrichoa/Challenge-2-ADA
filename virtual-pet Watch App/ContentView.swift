//
//  ContentView.swift
//  virtual-pet Watch App
//
//  Created by Hanna Nadia Savira on 03/06/25.
//

import SwiftUI

struct ContentView: View {
    @State private var path: [Route] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            HomeView(path: $path)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .workout:
//                        WorkoutTabView(path: $path)
                        WorkoutTabView()
                    case .store:
                        StoreView(path: $path)
                    case .summary:
                        StoreView(path: $path)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
