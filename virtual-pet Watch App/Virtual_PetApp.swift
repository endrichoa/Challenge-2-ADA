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
        UserDefaults.standard.register(
            defaults: [
                "daily_target": 20000,
                "coins": 20,
                "hunger": 10
            ]
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.font, .custom("Dogica Pixel", size: 17, relativeTo: .body))
        }
    }
}
