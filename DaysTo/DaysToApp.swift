//
//  DaysToApp.swift
//  DaysTo
//
//  Created by Killian Mathias on 05/04/2026.
//

import SwiftUI
import SwiftData

@main
struct DaysToApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Countdown.self)
        }
    }
}
