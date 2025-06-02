import Foundation
import SwiftUI

struct StepDay: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
}

class HistoryViewModel: ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var goalsReached: Int = 0
    @Published var avgSteps: Int = 0
    @Published var weeklyData: [(date: String, steps: Int)] = []
    
    private var dailyGoal: Int
    private var last7Days: [StepDay] = []
    
    init(dailyGoal: Int, last7Days: [StepDay]) {
        self.dailyGoal = dailyGoal
        self.last7Days = last7Days
        calculateStats()
    }
    
    private func calculateStats() {
        // 1. weeklyData
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        weeklyData = last7Days.map { (formatter.string(from: $0.date), $0.steps) }
        
        // 2. goalsReached
        goalsReached = last7Days.filter { $0.steps >= dailyGoal }.count
        
        // 3. avgSteps
        if !last7Days.isEmpty {
            avgSteps = last7Days.map { $0.steps }.reduce(0, +) / last7Days.count
        } else {
            avgSteps = 0
        }
        
        // 4. currentStreak
        currentStreak = 0
        for day in last7Days.sorted(by: { $0.date > $1.date }) {
            if day.steps >= dailyGoal {
                currentStreak += 1
            } else {
                break
            }
        }
    }
    
    // This function can be called with new data from HealthKit
    func updateData(dailyGoal: Int, last7Days: [StepDay]) {
        self.dailyGoal = dailyGoal
        self.last7Days = last7Days
        calculateStats()
    }
} 