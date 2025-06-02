//
//  StepModel.swift
//  virtual-pet
//
//  Created by Hanna Nadia Savira on 01/06/25.
//

import Foundation

struct StepModel: Identifiable {
    let id = UUID()
    let date: Date
    let stepCount: Double
    
    static let sampleData: [StepModel] = {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: today)!
            let steps = Double(Int.random(in: 3000...12000))
            return StepModel(date: date, stepCount: steps)
        }.reversed()
    }()
}
