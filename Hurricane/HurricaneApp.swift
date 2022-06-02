//
//  HurricaneApp.swift
//  Hurricane
//
//  Created by Asya Tealdi on 03/05/22.
//

import SwiftUI

@main
struct HurricaneApp: App {
   
    var body: some Scene {
        WindowGroup {
            CustomTabBarView()
                .preferredColorScheme(.light)
//            ContentView()
//            AnalyticsOverviewView()
        }
    }
}
