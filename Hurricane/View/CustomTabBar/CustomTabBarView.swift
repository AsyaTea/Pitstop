//
//  CustomTabBar.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI


struct CustomTabBarView: View {
    @State var selectedIndex: Int = 0
    @StateObject var dataVM = DataViewModel()
    @StateObject var homeVM = HomeViewModel()
    @StateObject var utilityVM : UtilityViewModel = .init()
    @StateObject var categoryVM = CategoryViewModel()
    @StateObject var onboardingVM = OnboardingViewModel()
    @StateObject var notificationVM = NotificationManager()
    
    init() {
        //  CUSTOM PROPRETIES FOR ALL LISTS OF THE APP
        UITableView.appearance().separatorStyle = .singleLine
        UITableView.appearance().backgroundColor = UIColor(Palette.greyBackground)
        UITableView.appearance().separatorColor = UIColor(Palette.greyLight)
        UITableView.appearance().showsVerticalScrollIndicator = false
    
    }

    
    var body: some View {
        CustomTabView(tabs: TabType.allCases.map({ $0.tabItem }), selectedIndex: $selectedIndex) { index in
            let type = TabType(rawValue: index) ?? .home
            getTabView(type: type)
        }
    }
    
    @ViewBuilder
    func getTabView(type: TabType) -> some View {
        switch type {
        case .home:
            VehicleView(onboardingVM: onboardingVM, dataVM: dataVM, homeVM: homeVM, utilityVM: utilityVM, categoryVM: categoryVM, notificationVM: notificationVM)
//                .statusBarStyle(.darkContent, ignoreDarkMode: true)
//            Content_View_3()
        case .stats:
//            WorkInProgress()
            AnalyticsOverviewView(dataVM: dataVM, categoryVM: categoryVM, utilityVM: utilityVM )
//                .statusBarStyle(.lightContent, ignoreDarkMode: false)
        case .settings:
            SettingsView(dataVM: dataVM, homeVM: homeVM, onboardingVM: onboardingVM)
//                .statusBarStyle(.lightContent, ignoreDarkMode: false)
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarView()
    }
}


