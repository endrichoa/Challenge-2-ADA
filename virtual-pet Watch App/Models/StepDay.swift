//
//  StepDay.swift
//  virtual-pet
//
//  Created by Hanna Nadia Savira on 02/06/25.
//

import Foundation


struct StepDay: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
}
