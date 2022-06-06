//
//  NotificationManager.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 03/06/22.
//

import Foundation
import NotificationCenter

class NotificationManager : ObservableObject {
    
    
    func requestAuthNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func createNotification(title: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = "Lorem ipsum doloris sit amet"
        content.sound = UNNotificationSound.default
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //MARK: TODO - modify the identifier
        let request = UNNotificationRequest(identifier: "3", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
}
