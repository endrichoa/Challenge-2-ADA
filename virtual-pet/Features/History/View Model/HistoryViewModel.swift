//
//  HistoryViewModel.swift
//  virtual-pet
//
//  Created by Hanna Nadia Savira on 29/05/25.
//

import Foundation
import HealthKit

@Observable
class HistoryViewModel {
    var weeklySteps: [StepModel]?
    var averageSteps: Double = 0
//    var histories: StepsHistoryModel
    
    init() {
        HealthKitHelper.shared.requestAuthorizationiOS { [weak self] authorized in
            guard authorized else {
                print("HealthKit not authorized")
                return
            }
            HealthKitHelper.shared.fetchWeeklySteps { [weak self] steps in
                DispatchQueue.main.async {
                    self?.weeklySteps = steps
                    var totalSteps: Double = 0
                    for step in steps {
                        totalSteps += step.stepCount
                    }
                    self?.averageSteps = totalSteps/Double(steps.count)
                }
            }
//            HealthKitHelper.shared.fetchWorkoutHistory { [weak self] workouts in
//                DispatchQueue.main.async {
////                    self?.histories = workouts.map { WorkoutModel(workout: $0) }
//                }
//            }
        }
    }
}
