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
        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
       
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



class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Here we actually handle the notification
        print("Notification received with identifier \(notification.request.identifier)")
        // So we call the completionHandler telling that the notification should display a banner and play the notification sound - this will happen while the app is in foreground
        completionHandler([.banner, .sound])
    }
}
