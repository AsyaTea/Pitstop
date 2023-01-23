//
//  HurricaneApp.swift
//  Hurricane
//
//  Created by Asya Tealdi on 03/05/22.
//

import SwiftUI

@main
struct HurricaneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            CustomTabBarView()
//            ContentView()
//            AnalyticsOverviewView()
        }
    }
}
