//
//  OnboardingView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import SwiftUI

enum Pages {
    case page1
    case page2
    case page3
    case page4
    case page5
}


struct MainContent: View {
    
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding : Bool = true
    
    var body: some View {
        NavigationView{
            VStack{
                Text("ciao")
            }
        }
        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
        })
    }
}

struct OnboardingView: View {
    
    @Binding var shouldShowOnboarding : Bool
    @State var destination : Pages = .page1
    
    var body: some View {
        switch destination {
            
        case .page1:
            Page1(destination: $destination)
//                .transition(.move(edge: .leading))
                .transition( AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                .animation(.easeInOut)
        case .page2:
            Page2(destination: $destination)
//                .transition( AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
//                .animation(.easeInOut)
        case .page3:
            Text("Hello, World!")
        case .page4:
            Text("Hello, World!")
        case .page5:
            Text("Hello, World!")
        }
        
    }
}

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        Page1(destination: $destination)
//    }
//}

struct Page1 : View {
    
    @Binding var destination : Pages
    
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            VStack(spacing:12){
                Text("Warm up your engine")
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text("Gear up for a simple way of managing your \nvehicle and cutting costs")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            Spacer()
            Image("page1")
            Spacer()
            VStack(spacing: 16){
                    OnBoardingButton(text: "Add a new vehicle", textColor: Palette.white, color: Palette.black)
                    .onTapGesture {
                        withAnimation(.easeInOut){
                        destination = .page2
                        }
                    }
            
                OnBoardingButton(text: "Import data", textColor: Palette.black, color: Palette.white)
                OnBoardingButton(text: "Restore from iCloud", textColor: Palette.black, color: Palette.white)
            }
            
        }.background(Palette.greyLight)
    }
}

struct Page2 : View {
    
    @Binding var destination : Pages
    
    var body: some View{
        VStack{
            HStack{
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 12, height: 21)
                    .foregroundColor(Palette.black)
                    .onTapGesture {
                        destination = .page1
                    }
                Spacer()
            }
            .padding()
            VStack(spacing:12){
                Text("Vehicle registration")
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text("Hop in and insert some key details")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            Spacer()
            OnBoardingButton(text: "next", textColor: Palette.white, color: Palette.black)
        }
        .background(Palette.greyLight)
    }
}


struct OnBoardingButton : View {
    
    var text : String
    var textColor : Color
    var color : Color
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055, alignment: .center)
                .cornerRadius(43)
                .foregroundColor(color)
            HStack{
                Spacer()
                Text(text)
                    .foregroundColor(textColor)
                    .font(Typography.ControlS)
                Spacer()
            }
        }
    }
}

