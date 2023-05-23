//
//  MainView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import SwiftUI

struct VehicleView: View {
    @StateObject var onboardingVM: OnboardingViewModel
    @StateObject var reminderVM = AddReminderViewModel()
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var homeVM: HomeViewModel
    @ObservedObject var utilityVM: UtilityViewModel
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var notificationVM: NotificationManager

    @AppStorage("shouldShowOnboardings") var shouldShowOnboarding: Bool = true
//    @State var shouldShowOnboarding : Bool = true //FOR TESTING
    @State private var showAddReport = false

    var body: some View {
        GeometryReader { proxy in
            let topEdge = proxy.safeAreaInsets.top
            HomeStyleView(dataVM: dataVM, homeVM: homeVM, categoryVM: categoryVM, topEdge: topEdge)
                .ignoresSafeArea(.all, edges: .top)
        }
        .overlay(
            VStack {
                Spacer(minLength: UIScreen.main.bounds.size.height * 0.77)
                Button(action: {
                    showAddReport.toggle()
                }, label: {
                    HStack {
                        Spacer()
                        Image("plus")
                            .resizable()
                            .foregroundColor(Palette.white)
                            .frame(width: 14, height: 14)
                        Text("Add report")
                            .foregroundColor(Palette.white)
                            .font(Typography.ControlS)
                        Spacer()
                    }
                })
                .buttonStyle(Primary())
                Spacer()
            }
        )
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showAddReport) {
            AddReportView(utilityVM: utilityVM, categoryVM: categoryVM, dataVM: dataVM, reminderVM: reminderVM)
        }
        .fullScreenCover(isPresented: $shouldShowOnboarding) {
            OnboardingView(onboardingVM: onboardingVM, dataVM: dataVM, categoryVM: categoryVM, shouldShowOnboarding: $shouldShowOnboarding)
        }
        .onAppear {
            if shouldShowOnboarding == false {
                dataVM.getCurrentVehicle()
            }
            homeVM.headerBackgroundColor = homeVM.loadColor(key: homeVM.COLOR_KEY)
            homeVM.headerCardColor = homeVM.loadColor(key: homeVM.COLOR_KEY_CARD)
        }
    }
}

struct VehicleView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleView(onboardingVM: OnboardingViewModel(), dataVM: DataViewModel(),
                    homeVM: HomeViewModel(), utilityVM: UtilityViewModel(),
                    categoryVM: CategoryViewModel(), notificationVM: NotificationManager())
    }
}
