//
//  MainView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import SwiftUI

struct VehicleView: View {
    // Onboarding vars
//    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding : Bool = true
    @State var shouldShowOnboarding: Bool = true // FOR TESTING
    @StateObject var onboardingVM = OnboardingViewModel()
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var homeVM: HomeViewModel
    @ObservedObject var utilityVM: UtilityViewModel
    @ObservedObject var categoryVM: CategoryViewModel
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
                    AddReportButton(text: "Add report")
                })
                Spacer()
            }
        )
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showAddReport) {
            AddReportView(utilityVM: utilityVM, categoryVM: categoryVM, dataVM: dataVM)
        }
        .onAppear {
            if shouldShowOnboarding == false {
                dataVM.getCurrentVehicle()
            }
        }
        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
            OnboardingView(onboardingVM: onboardingVM, dataVM: dataVM, shouldShowOnboarding: $shouldShowOnboarding)
        })
    }
}

// struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        VehicleView()
//    }
// }

struct AddReportButton: View {
    var text: String
    var body: some View {
        ZStack {
            Capsule(style: .continuous)
                .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055, alignment: .center)
                .foregroundColor(Palette.black)
            HStack {
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
