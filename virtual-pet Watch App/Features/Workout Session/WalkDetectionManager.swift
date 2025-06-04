import CoreMotion
import Foundation

class WalkDetectionManager: ObservableObject {
    private let pedometer = CMPedometer()
    private var isDetecting = false
    private var lastUpdateTime: Date?
    private var stepsSinceLastUpdate: Int = 0
    
    private let stepThreshold = 5
    private let timeThreshold: TimeInterval = 20 
    var isWalking: Bool = false
    var onWalkDetected: (() -> Void)?
    
    func startDetection() {
        guard !isDetecting else { return }
        isDetecting = true
        lastUpdateTime = nil
        stepsSinceLastUpdate = 0

        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting is not available")
            return
        }
        
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            guard let self = self,
                  let data = data,
                  error == nil else {
                return
            }
            
            let currentSteps = data.numberOfSteps.intValue
            let currentTime = Date()
            
            if self.lastUpdateTime == nil {
                self.lastUpdateTime = currentTime
                self.stepsSinceLastUpdate = currentSteps
                return
            }
            
            let stepsInWindow = currentSteps - self.stepsSinceLastUpdate
            let timeElapsed = currentTime.timeIntervalSince(self.lastUpdateTime!)
            
            if timeElapsed <= self.timeThreshold {
                if stepsInWindow >= self.stepThreshold && !self.isWalking {
                    self.isWalking = true
                    DispatchQueue.main.async {
                        self.onWalkDetected?()
                    }
                } else if stepsInWindow < self.stepThreshold && self.isWalking {
                    self.isWalking = false
                }
            }
            
            if timeElapsed > self.timeThreshold {
                self.lastUpdateTime = currentTime
                self.stepsSinceLastUpdate = currentSteps
                self.isWalking = false
            }
        }
    }
    
    func stopDetection() {
        guard isDetecting else { return }
        isDetecting = false
        pedometer.stopUpdates()
    }
    
    deinit {
        stopDetection()
    }
} 
