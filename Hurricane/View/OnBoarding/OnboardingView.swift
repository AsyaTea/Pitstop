//
//  OnboardingView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import SwiftUI
import UserNotifications


struct OnboardingView: View {
    
    @StateObject var onboardingVM : OnboardingViewModel
    @ObservedObject var dataVM : DataViewModel
    @ObservedObject var categoryVM : CategoryViewModel
    @State private var destination : Pages = .page1
    @Binding var shouldShowOnboarding : Bool
    @StateObject var fuelVM = FuelViewModel()
    
    
    var body: some View {
        switch onboardingVM.destination {
            
        case .page1:
            withAnimation(.easeOut){
                Page1(onboardingVM: onboardingVM)
            }
            
        case .page2:
            withAnimation(.easeOut(duration: 0.2)){
                Page2(onboardingVM: onboardingVM, fuelVM: fuelVM)
            }
        case .page3:
            Page3(dataVM:dataVM, onboardingVM: onboardingVM,fuelVM: fuelVM, categoryVM: categoryVM)
        case .page4:
            withAnimation(.easeInOut(duration: 0.2)){
                Page4(onboardingVM: onboardingVM)
            }
        case .page5:
            Page5(shouldShowOnboarding: $shouldShowOnboarding,onboardingVM: onboardingVM, dataVM: dataVM)
        }
        
    }
}

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainContent()
//    }
//}

