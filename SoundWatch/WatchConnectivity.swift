import Foundation
import WatchConnectivity

class WatchConnectivity: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    
    @Published var isConnectedToWatch: Bool = false
    @Published var isAppleWatchAppInstalled: Bool = false
    private var receivedDateManager: ReceivedDateManager
    
    init(session: WCSession = .default, receivedDateManager: ReceivedDateManager) {
        self.session = session
        self.receivedDateManager = receivedDateManager
        super.init()
        session.delegate = self
        session.activate()
        isConnectedToWatch = session.isReachable
        isAppleWatchAppInstalled = session.isWatchAppInstalled
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        DispatchQueue.main.async {
            self.isConnectedToWatch = session.isReachable
            self.isAppleWatchAppInstalled = session.isWatchAppInstalled
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isConnectedToWatch = session.isReachable
            self.isAppleWatchAppInstalled = session.isWatchAppInstalled
        }
    }
    
    func sendSoundGroupsToWatch(soundGroups: [SoundGroup]) {
        let enabledSoundGroups = soundGroups.filter { $0.isEnabled }
        
        if session.isReachable {
            print("Apple Watch is Reachable, Sending Sound Groups")
            
            let soundGroupsDict = enabledSoundGroups.reduce(into: [String: [String]]()) { dict, group in
                dict[group.name] = group.sounds
            }
            
            let message: [String: Any] = [
                "sender": "iPhone",
                "soundGroups": soundGroupsDict
            ]
            
            session.sendMessage(message, replyHandler: { response in
                if let receivedTime = response["timestamp"] as? TimeInterval {
                    let date = Date(timeIntervalSince1970: receivedTime)
                    print("Acknowledgement received from Watch at \(date)")
                    
                    DispatchQueue.main.async {
                        self.receivedDateManager.updateReceivedDate(date)
                    }
                }
            }, errorHandler: { error in
                print("Error sending message: \(error.localizedDescription)")
            })
        } else {
            print("Apple Watch is not Reachable, try again later.")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print(message)
    }
}
