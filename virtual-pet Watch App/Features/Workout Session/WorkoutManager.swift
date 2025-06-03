//
//  WorkoutManager.swift
//  virtual-pet Watch App
//
//  Created by Endricho Abednego on 22/05/25.
//

import Foundation
import HealthKit
import WorkoutKit

struct CoinBreakdown {
    let stepCoins: Int
    let distanceCoins: Int
    let timeCoins: Int
    let heartRateBonus: Int
    let achievementMultiplier: Double
    let finalCoins: Int
}

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
    @Published var steps: Int = 0
    
    // Workout state - now reflects HealthKit's actual session state
    @Published var running = false
    @Published var isPaused = false
    
    // Session state control
    @Published var showingSummaryView: Bool = false
    
    // Workout summary metrics
    @Published var averageHeartRate: Double = 0
    @Published var totalDistance: Double = 0
    @Published var totalCalories: Double = 0
    @Published var totalDuration: TimeInterval = 0
    @Published var totalSteps: Int = 0
    @Published var workoutDate: Date = Date()
    
    // Pause state tracking
    private var pausedDistance: Double = 0
    private var pausedSteps: Int = 0
    private var pausedSeconds: Int = 0
    private var pauseStartTime: Date?
    private var totalPausedTime: TimeInterval = 0
    
    // Raw values from HealthKit
    private var rawDistance: Double = 0
    private var rawSteps: Int = 0
    
    // Coins earned for this workout
    @Published var coinsEarned: Int = 0
    
    // Timer for updating the elapsed time
    private var timer: Timer?
    private var workoutStartTime: Date?
    
    // Step counter instance
    private let stepTracker = StepTrackerCM()
    
    func requestAuthorization() {
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.workoutType()
        ]
        
        let typesToShare: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.workoutType()
        ]
        
        HKHealthStore().requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if let error = error {
                print("HealthKit auth error: \(error.localizedDescription)")
            }
        }
    }
    
    var totalDistanceInKM: Double {
        return totalDistance / 1000
    }
    
    func startWorkout() {
        guard let workoutType = selectedWorkout else { return }
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor
        
        do {
            session = try HKWorkoutSession(healthStore: HKHealthStore(), configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
            
            let dataSource = HKLiveWorkoutDataSource(healthStore: HKHealthStore(), workoutConfiguration: configuration)
            if let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) {
                dataSource.enableCollection(for: stepType, predicate: nil)
            }
            builder?.dataSource = dataSource
            
            session?.delegate = self
            builder?.delegate = self
            
            let startDate = Date()
            workoutStartTime = startDate
            
            session?.startActivity(with: startDate)
            builder?.beginCollection(withStart: startDate) { success, error in
                if let error = error {
                    print("Begin collection error: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.running = true
                    self.isPaused = false
                    self.startTimer()
                    self.stepTracker.startCounting()
                }
            }
        } catch {
            print("Start workout error: \(error.localizedDescription)")
        }
    }
    
    // Manual pause function (still available if needed)
    func pauseWorkout() {
        session?.pause()
    }
    
    // Manual resume function (still available if needed)
    func resumeWorkout() {
        session?.resume()
    }
    
    func endWorkout() {
        session?.end()
        stopTimer()
        stepTracker.stopCounting()
    }
    
    func resetWorkout() {
        selectedWorkout = nil
        session = nil
        builder = nil
        running = false
        isPaused = false
        elapsedSeconds = 0
        activeCalories = 0
        heartRate = 0
        distance = 0
        steps = 0
        coinsEarned = 0
        showingSummaryView = false
        
        // Reset pause-related properties
        pausedDistance = 0
        pausedSteps = 0
        pausedSeconds = 0
        rawDistance = 0
        rawSteps = 0
        pauseStartTime = nil
        totalPausedTime = 0
        workoutStartTime = nil
        
        stopTimer()
        stepTracker.reset()
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateElapsedTime()
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateElapsedTime() {
        guard let startTime = workoutStartTime else { return }
        
        let totalElapsed = Date().timeIntervalSince(startTime)
        let activeTime = totalElapsed - totalPausedTime
        
        // If currently paused, subtract the current pause duration
        if isPaused, let pauseStart = pauseStartTime {
            let currentPauseDuration = Date().timeIntervalSince(pauseStart)
            elapsedSeconds = Int(activeTime - currentPauseDuration)
        } else {
            elapsedSeconds = Int(activeTime)
        }
        
        // Update steps from step tracker only when running
        if running && !isPaused {
            steps = max(rawSteps, stepTracker.totalSteps)
        }
    }
    
    // Handle automatic pause from HealthKit
    private func handleAutomaticPause() {
        DispatchQueue.main.async {
            self.isPaused = true
            self.running = false
            
            // Store current values when paused
            self.pausedDistance = self.distance
            self.pausedSteps = self.steps
            self.pausedSeconds = self.elapsedSeconds
            self.pauseStartTime = Date()
            
            self.stepTracker.pauseCounting()
        }
    }
    
    // Handle automatic resume from HealthKit
    private func handleAutomaticResume() {
        DispatchQueue.main.async {
            self.isPaused = false
            self.running = true
            
            // Add the pause duration to total paused time
            if let pauseStart = self.pauseStartTime {
                let pauseDuration = Date().timeIntervalSince(pauseStart)
                self.totalPausedTime += pauseDuration
                self.pauseStartTime = nil
            }
            
            self.stepTracker.startCounting()
        }
    }
    
    func canPauseWorkout() -> Bool {
        return session?.state == .running
    }
    
    func canResumeWorkout() -> Bool {
        return session?.state == .paused
    }
    

    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let unit = HKUnit.count().unitDivided(by: .minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: unit) ?? 0
                
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                self.activeCalories = statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                self.rawDistance = statistics.sumQuantity()?.doubleValue(for: .meter()) ?? 0
                
                // Update distance based on current state
                if !self.isPaused {
                    self.distance = self.rawDistance
                }
                
            case HKQuantityType.quantityType(forIdentifier: .stepCount):
                if let sum = statistics.sumQuantity() {
                    self.rawSteps = Int(sum.doubleValue(for: .count()))
                    
                    // Update steps based on current state
                    if !self.isPaused {
                        self.steps = max(self.rawSteps, self.stepTracker.totalSteps)
                    }
                }
            default:
                break
            }
        }
    }
    
    func collectWorkoutSummary() {
        guard let session = session else { return }
        workoutDate = Date()
        
        // Use the calculated elapsed time (excluding paused time)
        totalDuration = TimeInterval(elapsedSeconds)
        
        if let hrStats = builder?.statistics(for: .quantityType(forIdentifier: .heartRate)!) {
            averageHeartRate = hrStats.averageQuantity()?.doubleValue(for: .count().unitDivided(by: .minute())) ?? 0
        }
        if let calStats = builder?.statistics(for: .quantityType(forIdentifier: .activeEnergyBurned)!) {
            totalCalories = calStats.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
        }
        if let distStats = builder?.statistics(for: .quantityType(forIdentifier: .distanceWalkingRunning)!) {
            totalDistance = distStats.sumQuantity()?.doubleValue(for: .meter()) ?? 0
        }
        totalSteps = max(rawSteps, stepTracker.totalSteps)
        coinsEarned = calculateCoinsEarned()
        
        addCoins(coinsEarned: coinsEarned)
    }
    
    // COINS
    var coins: Int = UserDefaults.standard.integer(forKey: "coins")
    
    func addCoins(coinsEarned: Int) {
        coins += coinsEarned
        UserDefaults.standard.set(coins, forKey: "coins")
    }
    
    func calculateCoinsEarned() -> Int {
        var total = 0
        let km = totalDistance / 1000
        let stepCoins = totalSteps / 100
        let distCoins = Int(km * 10)
        let timeCoins = elapsedSeconds / 60
        let base = stepCoins + distCoins + timeCoins
        total += base
        total += calculateHeartRateBonus()
        total = Int(Double(total) * calculateAchievementMultiplier())
        return max(total, 1)
    }
    
    private func calculateHeartRateBonus() -> Int {
        guard averageHeartRate > 0 else { return 0 }
        let targetMin: Double = 120
        let targetMax: Double = 160
        let km = totalDistance / 1000
        let base = (totalSteps / 100) + Int(km * 10) + (elapsedSeconds / 60)
        if averageHeartRate >= targetMin && averageHeartRate <= targetMax {
            return Int(Double(base) * 0.2)
        } else if averageHeartRate > 100 && averageHeartRate < 180 {
            return Int(Double(base) * 0.1)
        }
        return 0
    }
    
    private func calculateAchievementMultiplier() -> Double {
        var multiplier = 1.0
        let km = totalDistance / 1000
        if elapsedSeconds >= 1800 { multiplier += 0.25 }
        if totalSteps >= 10000 { multiplier += 0.5 }
        if km >= 5.0 { multiplier += 0.3 }
        return multiplier
    }
    
    func getCoinBreakdown() -> CoinBreakdown {
        let km = totalDistance / 1000
        let stepCoins = totalSteps / 100
        let distCoins = Int(km * 10)
        let timeCoins = elapsedSeconds / 60
        let heartBonus = calculateHeartRateBonus()
        let base = stepCoins + distCoins + timeCoins + heartBonus
        let multiplier = calculateAchievementMultiplier()
        let total = max(Int(Double(base) * multiplier), 1)
        return CoinBreakdown(
            stepCoins: stepCoins,
            distanceCoins: distCoins,
            timeCoins: timeCoins,
            heartRateBonus: heartBonus,
            achievementMultiplier: multiplier,
            finalCoins: total
        )
    }
}

// MARK: - HKWorkoutSessionDelegate & HKLiveWorkoutBuilderDelegate

extension WorkoutManager: HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("Session changed from \(fromState) to \(toState)")
        
        // Handle automatic state changes from HealthKit
        switch toState {
        case .running:
            if fromState == .paused {
                handleAutomaticResume()
            }
        case .paused:
            if fromState == .running {
                handleAutomaticPause()
            }
        case .ended:
            builder?.endCollection(withEnd: date) { success, error in
                self.builder?.finishWorkout { _, _ in
                    DispatchQueue.main.async {
                        self.collectWorkoutSummary()
                        self.showingSummaryView = true
                    }
                }
            }
        default:
            break
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session error: \(error.localizedDescription)")
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Optional: handle workout events
    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { continue }
            let stats = workoutBuilder.statistics(for: quantityType)
            updateForStatistics(stats)
        }
    }
}
