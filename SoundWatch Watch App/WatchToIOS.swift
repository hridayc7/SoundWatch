//
//  WatchToIOS.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 1/28/25.
//

import Foundation
import WatchConnectivity
import SwiftData
import SwiftUI

class WatchToIOS: NSObject, WCSessionDelegate, ObservableObject{
    
    var session: WCSession
    private var modelContext: ModelContext // ✅ Store model context
    
    init(session: WCSession = .default, modelContext: ModelContext) {
        self.session = session
        self.modelContext = modelContext
        super.init()
        session.delegate = self
        session.activate()
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        if let soundGroups = message["soundGroups"] as? [String: [String]] {
            print("📩 Received sound groups: \(soundGroups)")
            
            var activeSoundsDict: [String: String] = [:]
            for (group, sounds) in soundGroups {
                for sound in sounds {
                    activeSoundsDict[sound] = group
                }
            }
            
            DispatchQueue.main.async {
                ActiveSounds.updateSounds(activeSoundsDict, modelContext: self.modelContext)
            }
        }
        
        let currentTime = Date().timeIntervalSince1970
        replyHandler(["status": "received", "timestamp": currentTime])
    }
    
    func sendMessageToiPhone(){
        if session.isReachable{
            print("iPhone is Reachable")
            let dummyMessage = ["content": "Hello iPhone!"]
            session.sendMessage(dummyMessage, replyHandler: nil)
        }
        else{
            print("iPhone is not Reachable")
        }
    }
    
    
    
    
}
