//
//  DaysToApp.swift
//  DaysTo
//
//  Created by Killian Mathias on 28/04/2026.
//
import SwiftUI
import SwiftData

@main
struct DaysToApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Event.self])
        
        guard let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.killianmathias.daysto") else {
            fatalError("App Group not found. Verify Signing & Capabilities.")
        }
        
        let fileURL = groupURL.appendingPathComponent("Events.sqlite")
        let modelConfiguration = ModelConfiguration(schema: schema, url: fileURL)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Impossible to create modelContainer : \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
