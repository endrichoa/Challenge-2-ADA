//
//  HomeViewModel.swift
//  virtual-pet
//
//  Created by Hanna Nadia Savira on 20/05/25.
//

import CoreMotion
import Foundation

@Observable
class HomeViewModel {
    // Private variables
    private let pedometer = CMPedometer()
    
    // Variables
    var currentSteps: Int = 5432
    var dailyTarget: Int = UserDefaults.standard.integer(forKey: "daily_target")
    var selectedDailyTarget: Int = 20000
    var progressBarPercentage: Double {
        return Double(currentSteps) / Double(dailyTarget)
    }
    
    // Pet stats
    var happinessLevel: Int = 80
    var hungerLevel: Int = 60
    
    // Page navigations
    var selectedTab: Int = 1
    var openItemPage: Bool = false
    var openEditPage: Bool = false
    
    func onOpenEditPage() {
        openEditPage = true
        selectedDailyTarget = dailyTarget
    }
    
    func fetchSteps() {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let now = Date()
        
        pedometer.queryPedometerData(from: startOfToday, to: now) { [weak self] data, error in
            DispatchQueue.main.async {
                if let steps = data?.numberOfSteps.intValue {
                    self?.currentSteps = steps
                }
            }
        }
    }
    
    func updateStepTarget() {
        UserDefaults.standard.set(selectedDailyTarget, forKey: "daily_target")
        dailyTarget = selectedDailyTarget
    }
    
    // Add steps from workout
     func addSteps(_ steps: Int) {
         currentSteps += steps
         // Save to persistent storage if needed
         saveSteps()
     }
     
     // Save steps to UserDefaults or other storage
     private func saveSteps() {
         UserDefaults.standard.set(currentSteps, forKey: "currentSteps")
     }
     
     // Load steps from storage
     func loadSteps() {
         currentSteps = UserDefaults.standard.integer(forKey: "currentSteps")
     }
     
     // Reset steps (e.g., at midnight)
     func resetSteps() {
         currentSteps = 0
         saveSteps()
     }
     
     // Initialize with stored data
     init() {
         loadSteps()
     }
}
