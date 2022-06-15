//
//  MainView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import SwiftUI

struct VehicleView: View {
    
    @StateObject var onboardingVM : OnboardingViewModel
    @StateObject var reminderVM = AddReminderViewModel()
    @ObservedObject var dataVM : DataViewModel
    @ObservedObject var homeVM : HomeViewModel
    @ObservedObject var utilityVM : UtilityViewModel
    @ObservedObject var categoryVM : CategoryViewModel
    @ObservedObject var notificationVM: NotificationManager
    
    @AppStorage("shouldShowOnboardings") var shouldShowOnboarding : Bool = true
//    @State var shouldShowOnboarding : Bool = true //FOR TESTING
    @State private var showAddReport = false
    
    
    var body: some View {
        GeometryReader{ proxy in
            let topEdge = proxy.safeAreaInsets.top
            HomeStyleView(dataVM: dataVM,homeVM:homeVM, categoryVM: categoryVM, topEdge: topEdge)
                .ignoresSafeArea(.all,edges: .top)
        }
        .overlay(
            VStack{
                Spacer(minLength: UIScreen.main.bounds.size.height * 0.77)
                Button(action: {
                    showAddReport.toggle()
                }, label: {
                    AddReportButton(text: "Add report")
                })
                Spacer()
            }
        )
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showAddReport) {
            AddReportView(utilityVM: utilityVM , categoryVM: categoryVM, dataVM: dataVM, reminderVM: reminderVM)
        }
        .fullScreenCover(isPresented: $shouldShowOnboarding){
            OnboardingView(onboardingVM: onboardingVM, dataVM: dataVM, categoryVM: categoryVM, shouldShowOnboarding: $shouldShowOnboarding)
        }
        .onAppear{
            if(shouldShowOnboarding == false){
                dataVM.getCurrentVehicle()
            }
            homeVM.headerBackgroundColor = homeVM.loadColor(key: homeVM.COLOR_KEY)
            homeVM.headerCardColor = homeVM.loadColor(key: homeVM.COLOR_KEY_CARD)
        }
        
    }
}

struct AddReportButton : View {
    
    var text : LocalizedStringKey
    var body: some View {
        
        ZStack{
            Capsule(style: .continuous)
                .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055, alignment: .center)
                .foregroundColor(Palette.black)
            HStack{
                Spacer()
                Image("plus")
                    .resizable()
                    .foregroundColor(Palette.white)
                    .frame(width: 14, height: 14)
                Text(text)
                    .foregroundColor(Palette.white)
                    .font(Typography.ControlS)
                Spacer()
            }
        }
    }
}



