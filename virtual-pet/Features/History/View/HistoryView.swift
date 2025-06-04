//
//  HistoryView.swift
//  virtual-pet
//
//  Created by Hanna Nadia Savira on 29/05/25.
//

import SwiftUI

struct HistoryView: View {
    @State private var vm = HistoryViewModel()
    
    var body: some View {
        VStack(alignment:.leading, spacing: 20) {
            Text("Weekly summary".uppercased())
                .font(.custom("Dogica Pixel", size: 17, relativeTo: .title3))
                .fontWeight(.bold)
                .padding(.horizontal, 20)
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Average steps: \(Int(vm.averageSteps)) steps")
                        .padding(.horizontal, 20)
                    WeeklyStepsChart(stepData: $vm.weeklySteps)
                        .frame(height: 280)
                        .padding(.top, 4)
                    Text("Workout History")
                        .padding(.horizontal, 20)
                }
            }
        }
        .background(Color("AppBlack"))
        .foregroundStyle(Color("AppWhite"))
    }
}

#Preview {
    HistoryView()
}
