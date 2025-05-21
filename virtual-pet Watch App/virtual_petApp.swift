//
//  virtual_petApp.swift
//  virtual-pet Watch App
//
//  Created by Hanna Nadia Savira on 16/05/25.
//

import SwiftUI

@main
struct virtual_pet_Watch_AppApp: App {
    init() {
        UserDefaults.standard.register(defaults: ["daily_target": 20000])
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
