//
//  DaysToApp.swift
//  DaysTo
//
//  Created by Killian Mathias on 28/04/2026.
//
import SwiftData
import SwiftUI

@main
struct DaysToApp: App {
    @State private var storeManager = StoreManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([DTEvent.self])

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
                .environment(storeManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
