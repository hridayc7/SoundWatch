//
//  ContentView.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 10/30/24.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext // ✅ Use SwiftData's global ModelContext
    // @EnvironmentObject var soundsManager: SoundsManager // ✅ Receives from `SoundWatchApp.swift`

    var body: some View {
        TabView {
            SoundGroupView()
                .tabItem {
                    Label("SoundGroups", systemImage: "waveform.badge.plus")
                }
            
            WatchStatusView()
                .tabItem {
                    Label("Watch", systemImage: "applewatch")
                }
        }
    }
}
