//
//  virtual_petApp.swift
//  virtual-pet
//
//  Created by Hanna Nadia Savira on 16/05/25.
//

import SwiftUI

@main
struct virtual_petApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.font, .custom("Dogica Pixel", size: 14, relativeTo: .body))
        }
    }
}
