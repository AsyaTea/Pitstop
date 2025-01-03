//
//  NotificationManager.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 03/06/22.
//

import Foundation
import NotificationCenter

final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestAuthNotifications() {
        let center = UNUserNotificationCenter.current()

        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("Notification authorization granted.")
                    } else if let error {
                        print("Notification authorization error: \(error.localizedDescription)")
                    }
                }
            case .denied:
                // TODO: Implement alert to enable notifications
                print("Notifications are denied.")
            case .authorized, .provisional, .ephemeral:
                print("Notifications are already enabled.")
            @unknown default:
                print("Unknown notification authorization status.")
            }
        }
    }

    func createNotification(for reminder: Reminder) {
        let isItalian = Locale.current.language.languageCode?.identifier == "it"
        let category = reminder.category.rawValue.lowercased()

        let notificationBody = isItalian
            ? "Hai un nuovo promemoria in \(category)"
            : "\(String(localized: "You have a new "))\(category)\(String(localized: " reminder"))"

        let content = UNMutableNotificationContent()
        content.title = reminder.title
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

    func removeNotification(for reminder: Reminder) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifiersToRemove = requests.filter { $0.identifier == reminder.uuid.uuidString }.map(\.identifier)

            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
            print("Notifications unscheduled: \(identifiersToRemove)")
        }
    }
}
