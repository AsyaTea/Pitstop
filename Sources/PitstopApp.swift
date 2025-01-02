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
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject var vehicleManager = VehicleManager()
    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: Document.self,
                                                Reminder.self,
                                                Vehicle2.self,
                                                Expense2.self,
                                                Number.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }

    var body: some Scene {
        WindowGroup {
            CustomTabBarView()
                .modelContainer(modelContainer)
                .environmentObject(vehicleManager)
//            ContentView()
//            AnalyticsOverviewView()
        }
    }
}
