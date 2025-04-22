//
//  SoundGroup.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 2/26/25.
//
// Model for the SoundGroup

import SwiftUI
import SwiftData
import Foundation

@Model
class SoundGroup {
    @Attribute(.unique) var id: UUID
    var name: String
    var isEnabled: Bool
    
    @Attribute(.externalStorage) var sounds: [String] // ✅ Uses @Attribute for optimized SwiftData storage

    init(name: String, isEnabled: Bool, sounds: [String] = []) {
        self.id = UUID()
        self.name = name
        self.isEnabled = isEnabled
        self.sounds = sounds
    }
}


