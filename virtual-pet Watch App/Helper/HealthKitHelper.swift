//
//  HealthKitHelper.swift
//  virtual-pet
//
//  Created by Hanna Nadia Savira on 22/05/25.
//

import HealthKit

@Observable
class HealthKitHelper {
    static let shared = HealthKitHelper()
    
    private let healthStore = HKHealthStore()
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        // The quantity types to read from HealthKit
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType(.stepCount),
            HKObjectType.workoutType()
        ]
        
        // The quantity types to share with HealthKit
        let typesToShare: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!, // Added for step tracking
            HKObjectType.workoutType()
        ]
//        let typesToRead: Set<HKObjectType> = [
//            HKQuantityType(.heartRate),
//            HKQuantityType(.stepCount)
//        ]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if let error = error {
                // handle errors
                print("Failed to authorize HealthKit: \(error.localizedDescription)")
                completion(false)
            }
            completion(success)
        }
    }
    
    var todaySteps: Int = 0
    func fetchTodayStepCount(completion: @escaping (Int?) -> Void) {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let now = Date()
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfToday,
            end: now,
            options: .strictStartDate
        )
        
        let queryStepCount = HKStatisticsQuery(
            quantityType: HKQuantityType(.stepCount),
            quantitySamplePredicate: predicate,
            options: .cumulativeSum) { query, statistics, error in
                guard let statistics = statistics, let sum = statistics.sumQuantity() else {
                    print("Error fetching step count: \(error?.localizedDescription ?? "No error")")
                    completion(nil)
                    return
                }
                let totalSteps = Int(sum.doubleValue(for: .count()))
                completion(totalSteps)
            }
        healthStore.execute(queryStepCount)
    }
}
