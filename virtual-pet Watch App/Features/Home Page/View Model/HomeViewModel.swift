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
    var initialSteps: Int = 0
    var currentSteps: Int = 0
    var totalSteps: Int {
        return initialSteps + currentSteps
    }
    var dailyTarget: Int = UserDefaults.standard.integer(forKey: "daily_target")
    var selectedDailyTarget: Int = 20000
    var progressBarPercentage: Double {
        return Double(totalSteps) / Double(dailyTarget)
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
        HealthKitHelper.shared.requestAuthorization { [weak self] authorized in
            guard authorized else {
                print("HealthKit not authorized")
                return
            }
            HealthKitHelper.shared.fetchTodayStepCount { [weak self] steps in
                DispatchQueue.main.async {
                    self?.initialSteps = steps ?? 0
                }
            }
        }
    }
    
    func updateSteps() {
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            if let steps = data?.numberOfSteps {
                DispatchQueue.main.async {
                    self?.currentSteps = Int(truncating: steps)
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
