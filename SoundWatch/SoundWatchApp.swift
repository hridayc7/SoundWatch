//
//  SoundWatchApp.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 10/30/24.
//

import SwiftUI
import SwiftData

@main
struct SoundWatchApp: App {
    private let modelContainer: ModelContainer
    // @StateObject private var soundsManager: SoundsManager
    @StateObject private var receivedDateManager: ReceivedDateManager
    @StateObject private var watchConnectivity: WatchConnectivity

    init() {
        // ✅ Initialize ModelContainer with SoundGroup for SwiftData
        do {
            self.modelContainer = try ModelContainer(for: SoundGroup.self, ReceivedDateModel.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }

        // ✅ Retrieve model context from the ModelContainer
        let modelContext = modelContainer.mainContext
        
        let receivedDateManagerInstance = ReceivedDateManager(modelContext: modelContext)

        // _soundsManager = StateObject(wrappedValue: SoundsManager(modelContext: modelContext))
        _receivedDateManager = StateObject(wrappedValue: receivedDateManagerInstance)
        _watchConnectivity = StateObject(wrappedValue: WatchConnectivity(receivedDateManager: receivedDateManagerInstance))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                // .environmentObject(soundsManager)
                .environmentObject(receivedDateManager)
                .environmentObject(watchConnectivity)
                .modelContainer(modelContainer) // ✅ Attach ModelContainer here
        }
    }
}
