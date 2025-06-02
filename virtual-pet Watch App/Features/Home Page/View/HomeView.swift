//
//  HomeView.swift
//  virtual-pet Watch App
//
//  Created by Hanna Nadia Savira on 19/05/25.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            TabView(selection: $viewModel.selectedTab) {
                RecordScreenBeforeView()
                    .tag(0)
                TabView {
                    PetView(vm: viewModel)
                    HistoryView()
                }
                .tabViewStyle(.verticalPage)
                .tag(1)
            }
            .tabViewStyle(.page)
            .onAppear() {
                viewModel.fetchSteps()
                viewModel.updateSteps()
            }
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
