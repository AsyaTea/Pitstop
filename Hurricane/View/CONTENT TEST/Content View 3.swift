//
//  Content View 3.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/06/22.
//

import SwiftUI

struct Content_View_3: View {
    
    @State var shouldShowOnboarding : Bool = true //FOR TESTING
    @StateObject var onboardingVM = OnboardingViewModel()
    @ObservedObject var dataVM = DataViewModel()
    @ObservedObject var categoryVM : CategoryViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .fullScreenCover(isPresented: $shouldShowOnboarding){
                OnboardingView(onboardingVM: onboardingVM, dataVM: dataVM, categoryVM: categoryVM, shouldShowOnboarding: $shouldShowOnboarding)
            }
    }
}

//struct Content_View_3_Previews: PreviewProvider {
//    static var previews: some View {
//        Content_View_3()
//    }
//}
