//
//  OnboardingView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import SwiftUI
import UserNotifications


enum Pages {
    case page1
    case page2
    case page3
    case page4
    case page5
}

//struct MainContent: View {
//
////    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding : Bool = true
//    @State var shouldShowOnboarding : Bool = true //FOR TESTING
//    @StateObject var onboardingVM = OnboardingViewModel()
//
//    var body: some View {
//        NavigationView{
//            VStack{
//                Text("ciao")
//            }
//        }
//        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
//            OnboardingView(onboardingVM: onboardingVM, shouldShowOnboarding: $shouldShowOnboarding)
//        })
//    }
//}

struct OnboardingView: View {
    
    @StateObject var onboardingVM = OnboardingViewModel()
    @State private var destination : Pages = .page1
    @Binding var shouldShowOnboarding : Bool
    
    var body: some View {
        switch destination {
            
        case .page1:
            Page1(destination: $destination)
            //                .transition(.move(edge: .leading))
            //                .transition( AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                .animation(.easeOut)
        case .page2:
            Page2(destination: $destination, onboardingVM: onboardingVM)
            //                .transition( AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                .animation(.easeOut(duration: 0.2))
        case .page3:
            Page3(destination: $destination)
        case .page4:
            Page4(destination: $destination, onboardingVM: onboardingVM)
                .animation(.easeOut(duration: 0.2))
        case .page5:
            Page5(shouldShowOnboarding: $shouldShowOnboarding, destination: $destination, onboardingVM: onboardingVM)
        }
        
    }
}

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainContent()
//    }
//}

