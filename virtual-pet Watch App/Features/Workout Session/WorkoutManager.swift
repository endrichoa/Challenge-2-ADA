//
//  WorkoutManager.swift
//  virtual-pet Watch App
//
//  Created by Endricho Abednego on 22/05/25.
//

//
import Foundation
import HealthKit
import WorkoutKit

class WorkoutManager: NSObject, ObservableObject {
    
    // Published properties to update the UI
    @Published var selectedWorkout: HKWorkoutActivityType?
    @Published var session: HKWorkoutSession?
    @Published var builder: HKLiveWorkoutBuilder?
    
    // Workout metrics
    @Published var heartRate: Double = 0
    @Published var activeCalories: Double = 0
    @Published var distance: Double = 0
    @Published var elapsedSeconds: Int = 0
    @Published var steps: Int = 0 // Added for step tracking
    
    // Workout staate
    @Published var running = false
    
    // Session state control
    @Published var showingSummaryView: Bool = false
    
    // Workout summary metrics
    @Published var averageHeartRate: Double = 0
    @Published var totalDistance: Double = 0
    @Published var totalCalories: Double = 0
    @Published var totalDuration: TimeInterval = 0
    @Published var totalSteps: Int = 0 // Added for step tracking
    @Published var workoutDate: Date = Date()
    
    // Timer for updating the elapsed time
    var timer = Timer()
    
    // Step counter instance
    private let stepTracker = StepTrackerCM()
    
    // Request authorization to access HealthKit
    func requestAuthorization() {
        // The quantity types to read from HealthKit
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
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
        
        // Request authorization
        HKHealthStore().requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            if let error = error {
                print("Error requesting HealthKit authorization: \(error.localizedDescription)")
            }
        }
    }
    
    // Start the workout session
    func startWorkout() {
        guard let workoutType = selectedWorkout else { return }
        
        // Configure the workout session
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor
        
        // Create the session and builder
        do {
            session = try HKWorkoutSession(healthStore: HKHealthStore(), configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
            
            // Configure the builder with step count
            let dataSource = HKLiveWorkoutDataSource(healthStore: HKHealthStore(), workoutConfiguration: configuration)
            if let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) {
                dataSource.enableCollection(for: stepType, predicate: nil)
            }
            builder?.dataSource = dataSource
            
            // Start the workout session
            session?.delegate = self
            builder?.delegate = self
            
            // Start the session and builder
            let startDate = Date()
            session?.startActivity(with: startDate)
            builder?.beginCollection(withStart: startDate) { (success, error) in
                if let error = error {
                    print("Error beginning collection: \(error.localizedDescription)")
                    return
                }
                
                // Start the timer and update the running state
                DispatchQueue.main.async {
                    self.running = true
                    self.startTimer()
                    // Start step counting
                    self.stepTracker.startCounting()
                }
            }
        } catch {
            print("Error starting workout: \(error.localizedDescription)")
            return
        }
    }
    
    // Pause the workout session
    func pauseWorkout() {
        session?.pause()
        running = false
        timer.invalidate()
        stepTracker.pauseCounting()
    }
    
    // Resume the workout session
    func resumeWorkout() {
        session?.resume()
        running = true
        startTimer()
        stepTracker.startCounting()
    }
    
    // End the workout session
    func endWorkout() {
        session?.end()
        timer.invalidate()
        stepTracker.stopCounting()
    }
    
    // Reset the workout session
    func resetWorkout() {
        selectedWorkout = nil
        session = nil
        builder = nil
        running = false
        elapsedSeconds = 0
        activeCalories = 0
        heartRate = 0
        distance = 0
        steps = 0
        showingSummaryView = false
        timer.invalidate()
        stepTracker.reset()
    }
    
    // Start the timer to update the elapsed time
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.elapsedSeconds += 1
            // Update steps from step tracker
            self?.steps = self?.stepTracker.totalSteps ?? 0
        }
    }
    
    // Update the metrics from the workout builder
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeCalories = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
                
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
                
            case HKQuantityType.quantityType(forIdentifier: .stepCount):
                let stepsUnit = HKUnit.count()
                if let sumQuantity = statistics.sumQuantity() {
                    self.steps = Int(sumQuantity.doubleValue(for: stepsUnit))
                } else if let mostRecentQuantity = statistics.mostRecentQuantity() {
                    self.steps = Int(mostRecentQuantity.doubleValue(for: stepsUnit))
                }
                
            default:
                return
            }
        }
    }
    
    // Collect the workout summary
    func collectWorkoutSummary() {
        guard let session = session else { return }
        
        workoutDate = Date()
        // Safely unwrap the startDate before using timeIntervalSince
        if let startDate = session.startDate {
            totalDuration = Date().timeIntervalSince(startDate)
        } else {
            totalDuration = 0
        }
        
        // Use the builder's statistics to get metrics
        if let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate),
           let statistics = builder?.statistics(for: heartRateType) {
            let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
            averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
        }
        
        if let caloriesType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned),
           let statistics = builder?.statistics(for: caloriesType) {
            let energyUnit = HKUnit.kilocalorie()
            totalCalories = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
        }
        
        if let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
           let statistics = builder?.statistics(for: distanceType) {
            let meterUnit = HKUnit.meter()
            totalDistance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
        }
        
        // Update total steps from step tracker
        totalSteps = stepTracker.totalSteps
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            switch toState {
            case .running:
                self.running = true
            case .paused:
                self.running = false
            case .ended:
                self.showingSummaryView = true
                self.collectWorkoutSummary()
                self.builder?.endCollection(withEnd: date) { (success, error) in
                    if let error = error {
                        print("Error ending collection: \(error.localizedDescription)")
                    }
                    
                    self.builder?.finishWorkout { (workout, error) in
                        if let error = error {
                            print("Error finishing workout: \(error.localizedDescription)")
                        }
                    }
                }
            default:
                break
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed with error: \(error.localizedDescription)")
    }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { return }
            
            let statistics = workoutBuilder.statistics(for: quantityType)
            updateForStatistics(statistics)
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Handle workout events if needed
    }
}
