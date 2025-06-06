//
//  EditTargetView.swift
//  virtual-pet Watch App
//
//  Created by Hanna Nadia Savira on 21/05/25.
//

import SwiftUI

struct EditTargetView: View {
    @Environment(\.dismiss) var dismiss
    @State var vm: HomeViewModel
    
    private let range = stride(from: 8000, through: 50000, by: 1000).map { $0 }
    
    var body: some View {
        VStack {
            Picker("Steps Goal", selection: $vm.selectedDailyTarget) {
                ForEach(range, id: \.self) { value in
                    Text("\(value)")
                        .tag(value)
                }
            }
            .pickerStyle(.wheel)
            Button(
                action: {
                    vm.updateStepTarget()
                    dismiss()
                }
            ) {
                Text("Done")
            }
        }
    }
}

#Preview {
    EditTargetView(vm: HomeViewModel())
}
