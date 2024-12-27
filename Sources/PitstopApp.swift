//
//  PitstopApp.swift
//  Hurricane
//
//  Created by Asya Tealdi on 03/05/22.
//

import SwiftData
import SwiftUI

@main
struct PitstopApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            CustomTabBarView()
                .modelContainer(for: [Document.self, Reminder2.self])
//            ContentView()
//            AnalyticsOverviewView()
        }
    }
}
