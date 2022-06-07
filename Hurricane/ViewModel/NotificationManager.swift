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
    
    func createNotification(reminderS: ReminderState) {
        let content = UNMutableNotificationContent()
        content.title = reminderS.title
        content.subtitle = "You have a reminder set on \(String(describing: reminderS.category))"
        content.sound = UNNotificationSound.default
        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: true)
       
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.day, .month, .year, .hour, .minute],from: reminderS.date), repeats: false)

        
        //MARK: TODO - modify the identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
              print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                 }
            } 
    }
    
}
