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
                PetView(vm: viewModel)
                    .tag(1)
            }
            .tabViewStyle(.page)
        }
    }
}

#Preview {
    HomeView()
}
