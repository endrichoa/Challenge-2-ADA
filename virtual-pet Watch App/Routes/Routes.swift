//
//  Route.swift
//  virtual-pet
//
//  Created by Hanna Nadia Savira on 03/06/25.
//

enum Routes: Hashable {
    case workout
    case summary(workoutManager: WorkoutManager)
    case store
}
