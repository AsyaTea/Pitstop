//
//  OnboardingView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import SwiftUI
import UserNotifications


//TESTING
struct MainContent: View {

//    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding : Bool = true
    @State var shouldShowOnboarding : Bool = false //FOR TESTING
    @StateObject var onboardingVM = OnboardingViewModel()
    @StateObject var dataVM = DataViewModel()
    @StateObject var categoryVM = CategoryViewModel()

    var body: some View {
        NavigationView{
            VStack{
            Button("remove all"){
                dataVM.removeAllVehicles()
            }
                List(dataVM.vehicles,id: \.id){ vehicle in
                
                    VStack{
                        Text(vehicle.name ?? "")
                        Text(vehicle.brand ?? "")
                        Text(vehicle.model ?? "")
                    }
                }
            }
            .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
                OnboardingView(onboardingVM: onboardingVM, dataVM: dataVM, shouldShowOnboarding: $shouldShowOnboarding)
            })

        }
//        .onAppear{
//            dataVM.getVehicles()
//        }
    }
}

struct OnboardingView: View {
    
    @StateObject var onboardingVM : OnboardingViewModel
    var dataVM : DataViewModel
    @State private var destination : Pages = .page1
    @Binding var shouldShowOnboarding : Bool
    
    
    var body: some View {
        switch onboardingVM.destination {
            
        case .page1:
            withAnimation(.easeOut){
                Page1(onboardingVM: onboardingVM)
            //                .transition(.move(edge: .leading))
            //                .transition( AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }
        case .page2:
            withAnimation(.easeOut(duration: 0.2)){
                Page2(onboardingVM: onboardingVM)
            }
        case .page3:
            Page3(dataVM:dataVM, onboardingVM: onboardingVM)
        case .page4:
            Page4(onboardingVM: onboardingVM)
                .animation(.easeOut(duration: 0.2))
        case .page5:
            Page5(shouldShowOnboarding: $shouldShowOnboarding,onboardingVM: onboardingVM)
        }
        
    }
}

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainContent()
//    }
//}

