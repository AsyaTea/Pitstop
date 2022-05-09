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

enum FocusFieldBoarding: Hashable {
    case carName
    case brand
    case model
    case fuelType
    
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
            //                .transition( AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                .animation(.easeOut)
        case .page2:
            Page2()
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

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Page2()
    }
}

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
                Button(action: {
                    withAnimation(.easeInOut){
                        destination = .page2
                    }
                }, label: {
                    OnBoardingButton(text: "Add a new vehicle", textColor: Palette.white, color: Palette.black)
                })
                OnBoardingButton(text: "Import data", textColor: Palette.black, color: Palette.white)
                OnBoardingButton(text: "Restore from iCloud", textColor: Palette.black, color: Palette.white)
            }
            
        }.background(Palette.greyBackground)
    }
}

struct Page2 : View {
    
    //    @Binding var destination : Pages
    
    @FocusState var focusedField: FocusFieldBoarding?
    
    @State private var carName : String = ""
    @State private var brand : String = ""
    @State private var model : String = ""
    @State private var fuelType : String = ""
    
    let haptic = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View{
        VStack{
            HStack{
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 12, height: 21)
                    .foregroundColor(Palette.black)
                    .onTapGesture {
                        //                        destination = .page1
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
            VStack(spacing:16){
                
                TextField("Car's name", text: $carName)
                    .disableAutocorrection(true)
                    .focused($focusedField,equals: .carName)
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(Palette.greyLight)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(RoundedRectangle(cornerRadius: 36)
                        .stroke(focusedField == .carName ? Palette.black :Palette.greyInput, lineWidth: 1))
                    .modifier(ClearButton(text: $carName))
                
                
                TextField("Brand", text: $brand)
                    .disableAutocorrection(true)
                    .focused($focusedField,equals: .brand)
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(Palette.greyLight)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(RoundedRectangle(cornerRadius: 36)
                        .stroke(focusedField == .brand ? Palette.black :Palette.greyInput, lineWidth: 1))
                    .modifier(ClearButton(text: $brand))
                
                
            }
            Spacer()
            OnBoardingButton(text: "Next", textColor: Palette.white, color: Palette.black)
        }
        .background(Palette.greyBackground)           
        .onTapGesture {
            focusedField = nil
        }
    }
    
}


struct OnBoardingButton : View {
    
    var text : String
    var textColor : Color
    var color : Color
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.060, alignment: .center)
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


struct ClearButton: ViewModifier{
    
    @Binding var text: String
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .trailing){
            content
            
            if (!text.isEmpty) {
                Button(action:{
                    self.text = ""
                }){
                    Image(systemName: "xmark")
//                        .resizable()
//                        .frame(width: 12, height: 12)
                        .foregroundColor(Palette.black)
                }
                .padding(.trailing, 20)
            }
        }
    }
}
