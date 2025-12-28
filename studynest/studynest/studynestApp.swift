//
//  studynestApp.swift
//  studynest
//
//  StudyNest iOS App Entry Point
//

import SwiftUI
import SwiftData

@main
struct StudyNestApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserEntity.self,
            BookingEntity.self,
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
