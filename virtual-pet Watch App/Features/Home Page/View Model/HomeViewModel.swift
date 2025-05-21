//
//  HomeViewModel.swift
//  virtual-pet
//
//  Created by Hanna Nadia Savira on 20/05/25.
//

import Foundation

@Observable
class HomeViewModel {
    // Page navigations
    var selectedTab: Int = 1
    var openItemPage: Bool = false
    var openEditPage: Bool = false
    
    func onOpenEditPage() {
        openEditPage = true
    }
    
    // Variables
    var currentSteps: Int = 6537
    var dailyStepsGoal: Int = 20000
    var progressBar: Double {
        return Double(currentSteps) / Double(dailyStepsGoal)
    }
    
    var happinessLevel: Int = 80
    var hungerLevel: Int = 60
}
