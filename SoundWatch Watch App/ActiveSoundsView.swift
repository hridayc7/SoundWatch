//
//  ActiveSoundsView.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 3/2/25.
//


import SwiftUI
import SwiftData

struct ActiveSoundsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var activeSounds: [ActiveSounds]

    var body: some View {
        NavigationView {
            List {
                if let activeSounds = activeSounds.first {
                    ForEach(activeSounds.sounds.keys.sorted(), id: \.self) { sound in
                        HStack {
                            Text(Utilities.soundToDisplayName(sound))
                            Spacer()
                            Text(activeSounds.sounds[sound] ?? "Unknown Group")
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    Text("No active sounds available.")
                }
            }
            .navigationTitle("Active Sounds")
        }
    }
}
