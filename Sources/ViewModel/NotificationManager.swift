//
//  NotificationManager.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 03/06/22.
//

import Foundation
import NotificationCenter

class NotificationManager: ObservableObject {
    func requestAuthNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notification authorization granted.")
            } else if let error {
                print("Notification authorization error: \(error.localizedDescription)")
            }
        }
    }

    func createNotification(for reminder: Reminder2) {
        let isItalian = Locale.current.language.languageCode?.identifier == "it"
        let category = reminder.category.rawValue.lowercased()

        let notificationBody = isItalian
            ? "Hai un nuovo promemoria in \(category)"
            : "\(String(localized: "You have a new "))\(category)\(String(localized: " reminder"))"

        let content = UNMutableNotificationContent()
        content.title = reminder.title ?? ""
        content.body = notificationBody
        content.sound = .default

        let triggerDateComponents = Calendar.current.dateComponents([
            .day, .month, .year, .hour, .minute
        ], from: reminder.date)

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: reminder.uuid.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Error adding notification request: \(error.localizedDescription)")
            }
        }
    }

    func removeNotification(for reminder: Reminder2) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifiersToRemove = requests.filter { $0.identifier == reminder.uuid.uuidString }.map(\.identifier)

            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
            print("Notifications unscheduled: \(identifiersToRemove)")
        }
    }
}
