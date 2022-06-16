//
//  NotificationManager.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 03/06/22.
//

import Foundation
import NotificationCenter

class NotificationManager : ObservableObject {
    
    @Published var id : String = ""
    
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
        
        var isIta : Bool {
            return Locale.current.languageCode == "it"
        }
        var reminderEng = (String(localized:"You have a new ") + String(category?.label.lowercased() ?? "") + String(localized: " reminder"))
        var reminderIta = "Hai un nuovo promemoria in \(category?.label.lowercased() ?? "")"
        
        let content = UNMutableNotificationContent()
        self.id = reminderS.reminderID?.uriRepresentation().absoluteString ?? UUID().uuidString
        print(id)
        content.title = reminderS.title
        content.body = (isIta ? reminderIta : reminderEng)
        
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.day, .month, .year, .hour, .minute],from: reminderS.date), repeats: false)
        let request = UNNotificationRequest(identifier: self.id , content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    func removeNotification(reminderS: ReminderState){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == self.id {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            print("Notification Unscheduled with",identifiers)
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
        print("Notification received with identifier \(notification.request.identifier)")
        completionHandler([.banner, .sound])
    }
}
