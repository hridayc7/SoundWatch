//
//  MockModels.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 2/26/25.
//
import SwiftUI

class MockWatchConnectivity: ObservableObject {
    @Published var isAppleWatchAppInstalled = true
    @Published var isConnectedToWatch = true
    
//    func sendActiveSoundsToWatch(soundsManager: SoundsManager) {
//        print("Mock: Syncing sounds to watch")
//    }
}


class MockSoundsManager: ObservableObject {
    @Published var sounds: [String] = ["Doorbell", "Dog Bark", "Glass Breaking"]
}


class MockReceivedDateManager: ObservableObject {
    @Published var latestReceivedDate: Date? = Date()
}
