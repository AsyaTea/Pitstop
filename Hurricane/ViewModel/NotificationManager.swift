//
//  NotificationManager.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 03/06/22.
//

import Foundation
import NotificationCenter

class NotificationManager : ObservableObject {
    
    @Published var notificationDate: Date = Date()
    @Published var secondsElapsed: Int = 0
    
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
        let category = Category.init(rawValue: Int(reminderS.category ?? 0))
        let content = UNMutableNotificationContent()
        content.title = reminderS.title
        content.subtitle = "You have a new \(category?.label ?? "") reminder"
        content.sound = UNNotificationSound.default
        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(secondsElapsed), repeats: false)
       
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.day, .month, .year, .hour, .minute],from: reminderS.date), repeats: false)
        
        print(reminderS.date - TimeInterval(secondsElapsed))
        
        //MARK: TODO - modify the identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
              print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                 }
            } 
    }
    
    func movingToBackground() {
          print("Moving to the background")
          notificationDate = Date()
//          stopWatchManager.pause()
      }

      func movingToForeground() {
          print("Moving to the foreground")
          let deltaTime: Int = Int(Date().timeIntervalSince(notificationDate))
          self.secondsElapsed += deltaTime
//          stopWatchManager.start()
      }
    
}
