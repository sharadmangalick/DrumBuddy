//
//  DrumBuddyApp.swift
//  DrumBuddy
//
//  A drumming practice app for kids
//

import SwiftUI
import SwiftData

@main
struct DrumBuddyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ProgressRecord.self,
            PatternStats.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
