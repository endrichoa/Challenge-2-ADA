//
//  stepsCounter.swift
//  virtual-pet Watch App
//
//  Created by Endricho Abednego on 22/05/25.
//


import CoreMotion
import Foundation

@Observable
class StepTrackerCM {
    var initialSteps: Int = 0
    var liveSteps: Int = 0
    private var isCounting: Bool = false
    
    private let pedometer = CMPedometer()
    
    init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        guard CMPedometer.isStepCountingAvailable() else { return }
    }
    
    var totalSteps: Int {
        return initialSteps + liveSteps
    }
    
    func startCounting() {
        guard !isCounting else { return }
        isCounting = true
        
        // Reset previous counts
        initialSteps = 0
        liveSteps = 0
        
        // Get initial steps from the start of the workout
        let startDate = Date()
        pedometer.queryPedometerData(from: startDate, to: startDate) { [weak self] data, error in
            DispatchQueue.main.async {
                if let steps = data?.numberOfSteps.intValue {
                    self?.initialSteps = steps
                }
            }
        }
        
        // Start live updates
        pedometer.startUpdates(from: startDate) { [weak self] data, error in
            guard let self = self, self.isCounting else { return }
            if let steps = data?.numberOfSteps {
                DispatchQueue.main.async {
                    self.liveSteps = Int(truncating: steps) - self.initialSteps
                }
            }
        }
    }
    
    func pauseCounting() {
        isCounting = false
        pedometer.stopUpdates()
    }
    
    func stopCounting() {
        isCounting = false
        pedometer.stopUpdates()
        // Don't reset the counts here as we want to keep them for the summary
    }
    
    func reset() {
        isCounting = false
        pedometer.stopUpdates()
        initialSteps = 0
        liveSteps = 0
    }
}


