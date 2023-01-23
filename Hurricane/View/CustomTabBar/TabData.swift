//
//  TabBarModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import Foundation

// Data to pass to the tab items
struct TabItemData {
    let image: String
}

enum TabType: Int, CaseIterable {
    case home = 0
    case stats
    case settings

    var tabItem: TabItemData {
        switch self {
        case .home:
            return TabItemData(image: "carIcon")
        case .stats:
            return TabItemData(image: "chartIcon")
        case .settings:
            return TabItemData(image: "settingsIcon")
        }
    }
}
