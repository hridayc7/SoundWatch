//
//  NotificationHandler.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 1/28/25.
//

import UserNotifications

class NotificationHandler {
    static let shared = NotificationHandler()
    
    private init() {}

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    func scheduleNotification(for soundIdentifier: String, in soundGroup: String) {
        let content = UNMutableNotificationContent()
        content.title = "Sound Detected"
        content.body = "Detected '\(soundIdentifier)' in sound group '\(soundGroup)'."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled for '\(soundIdentifier)' in group '\(soundGroup)'.")
            }
        }
    }
}
