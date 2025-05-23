//
//  HomeView.swift
//  virtual-pet Watch App
//
//  Created by Hanna Nadia Savira on 19/05/25.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var selectedVerticalTab = 0
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedVerticalTab) {
                // Main content
                TabView(selection: $viewModel.selectedTab) {
                    RecordScreenBeforeView()
                        .tag(0)
                    PetView(vm: viewModel)
                        .tag(1)
                }
                .tabViewStyle(.page)
                .onAppear() {
                    viewModel.fetchSteps()
                }
                .tag(0)
                
                // History View
                HistoryView()
                    .tag(1)
            }
            .tabViewStyle(.page)
            .onAppear() {
                viewModel.fetchSteps()
                viewModel.updateSteps()
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .navigationDestination(isPresented: $viewModel.openEditPage) {
                EditTargetView(vm: viewModel)
            }
        }
        .fontWeight(.bold)
    }
}

#Preview {
    HomeView()
}
