//import Foundation
//import SwiftData
//
//@Model class SoundsModel {
//    @Attribute(.unique) var soundName: String
//
//    init(soundName: String) {
//        self.soundName = soundName
//    }
//}
//
//class SoundsManager: ObservableObject {
//    @Published private(set) var sounds: Set<String> = []
//    private var modelContext: ModelContext
//
//    init(modelContext: ModelContext) {
//        self.modelContext = modelContext
//        loadSounds()
//    }
//
//    /// Loads sounds from persistent storage or initializes with default sounds
//    private func loadSounds() {
//        do {
//            let savedSounds = try modelContext.fetch(FetchDescriptor<SoundsModel>())
//            if savedSounds.isEmpty {
//                self.sounds = [
//                    "Your Mom",
//                ]
//                try saveInitialSounds()
//            } else {
//                self.sounds = Set(savedSounds.map { $0.soundName })
//            }
//        } catch {
//            print("❌ Error loading sounds: \(error.localizedDescription)")
//        }
//    }
//
//    /// Saves the initial set of default sounds to persistent storage
//    private func saveInitialSounds() throws {
//        for sound in sounds {
//            try addSoundToPersistentStorage(sound: sound)
//        }
//    }
//
//    /// Adds a new sound to persistent storage
//    private func addSoundToPersistentStorage(sound: String) throws {
//        let soundModel = SoundsModel(soundName: sound)
//        modelContext.insert(soundModel)
//        try saveContext()
//    }
//
//    /// Removes a sound from persistent storage
//    private func removeSoundFromPersistentStorage(sound: String) throws {
//        do {
//            let fetchDescriptor = FetchDescriptor<SoundsModel>(predicate: #Predicate { $0.soundName == sound })
//            if let soundToRemove = try modelContext.fetch(fetchDescriptor).first {
//                modelContext.delete(soundToRemove)
//                try saveContext()
//            }
//        } catch {
//            print("❌ Error removing sound '\(sound)': \(error.localizedDescription)")
//            throw error
//        }
//    }
//
//    /// Saves the current state of the model context
//    private func saveContext() throws {
//        do {
//            try modelContext.save()
//        } catch {
//            print("❌ Error saving context: \(error.localizedDescription)")
//            throw error
//        }
//    }
//
//    /// Public method to add a sound (Ensures unique values)
//    func addSound(_ sound: String) {
//        guard !sounds.contains(sound) else { return }
//        sounds.insert(sound)
//        do {
//            try addSoundToPersistentStorage(sound: sound)
//        } catch {
//            print("❌ Error adding sound '\(sound)': \(error.localizedDescription)")
//        }
//    }
//
//    /// Public method to remove a sound
//    func removeSound(_ sound: String) {
//        guard sounds.contains(sound) else { return }
//        sounds.remove(sound)
//        do {
//            try removeSoundFromPersistentStorage(sound: sound)
//        } catch {
//            print("❌ Error removing sound '\(sound)': \(error.localizedDescription)")
//        }
//    }
//}
