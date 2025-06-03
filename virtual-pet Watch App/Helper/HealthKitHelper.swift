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
    
    func fetchStepsForLast7Days(completion: @escaping ([StepDay]) -> Void) {
        let calendar = Calendar.current
        let now = Date()
        var days: [StepDay] = Array(repeating: StepDay(date: now, steps: 0), count: 7)
        let group = DispatchGroup()
        
        for i in 0..<7 {
            group.enter()
            let date = calendar.date(byAdding: .day, value: -i, to: now)!
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
            
            let query = HKStatisticsQuery(
                quantityType: HKQuantityType(.stepCount),
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, statistics, _ in
                let steps = statistics?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                days[i] = StepDay(date: startOfDay, steps: Int(steps))
                group.leave()
            }
            healthStore.execute(query)
        }
        
        group.notify(queue: .main) {
            // Sort by date ascending
            let sorted = days.sorted { $0.date < $1.date }
            completion(sorted)
        }
    }
    
    func requestAuthorizationiOS(completion: @escaping (Bool) -> Void) {
        // The quantity types to read from HealthKit
        let typesToRead: Set<HKObjectType> = [
            HKQuantityType(.heartRate),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.stepCount),
            HKObjectType.workoutType()
        ]
        
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            if let error = error {
                // handle errors
                print("Failed to authorize HealthKit: \(error.localizedDescription)")
                completion(false)
            }
            completion(success)
        }
    }
    
    func fetchWeeklySteps(completion: @escaping ([StepModel]) -> Void) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            print("1: error completion empty array")
            completion([])
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now))!
        let interval = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: calendar.startOfDay(for: now),
            intervalComponents: interval
        )
        print("2: initialize query")
        query.initialResultsHandler = { query, results, error in
            var stepData: [StepModel] = []
            
            if let statsCollection = results {
                print("3: enumerate statistics")
                statsCollection.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                    print("4: append step")
                    let steps = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0
                    stepData.append(StepModel(date: statistics.startDate, stepCount: steps))
                }
            }
            DispatchQueue.main.async {
                print("6: call completion")
                print("step data: $\(stepData)")
                completion(stepData)
            }
        }
        
        healthStore.execute(query)
    }
    
    
    func fetchWorkoutHistory(completion: @escaping ([HKWorkout]) -> Void) {
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.date(byAdding: .day, value: -7, to: now)
        
        let workoutType = HKObjectType.workoutType()
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfWeek,
            end: now,
            options: .strictStartDate
        )
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(
            sampleType: workoutType,
            predicate: predicate,
            limit: 0,
            sortDescriptors: [sortDescriptor]
        ) { _, samples, error in
            guard let workouts = samples as? [HKWorkout], error == nil else {
                print("Error fetching workouts: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            completion(workouts)
        }
        healthStore.execute(query)
    }
}
