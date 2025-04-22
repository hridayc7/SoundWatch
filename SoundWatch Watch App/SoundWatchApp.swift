//
//  SoundWatchApp.swift
//  SoundWatch Watch App
//
//  Created by Hriday Chhabria on 10/30/24.
//

import SwiftUI
import SwiftData

@main
struct SoundWatchApp: App {
    private let modelContainer: ModelContainer
    @StateObject private var watchToIOS: WatchToIOS

    init() {
        do {
            self.modelContainer = try ModelContainer(for: ActiveSounds.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }

        // Pass model context when creating WatchToIOS
        let modelContext = modelContainer.mainContext
        _watchToIOS = StateObject(wrappedValue: WatchToIOS(modelContext: modelContext))
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView(modelContext: modelContainer.mainContext)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                ActiveSoundsView()
                    .tabItem {
                        Label("Active Sounds", systemImage: "waveform")
                    }
            }
            .modelContainer(modelContainer)
            .environmentObject(watchToIOS) // Provide WatchToIOS as an environment object
        }
    }
}

