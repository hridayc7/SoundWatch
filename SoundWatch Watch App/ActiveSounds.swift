//
//  ActiveSounds.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 3/2/25.
//


import SwiftData

@Model
class ActiveSounds {
    @Attribute(.unique) var id: String = "active_sounds"
    var sounds: [String: String] = [:]

    init() {}

    /// Updates and saves active sounds
    static func updateSounds(_ newSounds: [String: String], modelContext: ModelContext) {
        let fetchDescriptor = FetchDescriptor<ActiveSounds>()
        if let existing = try? modelContext.fetch(fetchDescriptor).first {
            existing.sounds = newSounds
        } else {
            let newActiveSounds = ActiveSounds()
            newActiveSounds.sounds = newSounds
            modelContext.insert(newActiveSounds)
        }

        do {
            try modelContext.save()
            print("✅ Successfully updated ActiveSounds in SwiftData")
        } catch {
            print("❌ Error saving ActiveSounds: \(error.localizedDescription)")
        }
    }
}
