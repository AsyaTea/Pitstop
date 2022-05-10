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
            Page2(destination: $destination)
            //                .transition( AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
            //                .animation(.easeInOut)
        case .page3:
            Page3()
        case .page4:
            Page4(destination: $destination)
        case .page5:
            Page5()
        }
        
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Page5()
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
    
    @Binding var destination : Pages
    
    @FocusState var focusedField: FocusFieldBoarding?
    
    @State private var carName : String = ""
    @State private var brand : String = ""
    @State private var model : String = ""
    
    let fuelCategories = ["Gasoline","Diesel", "Electricity", "Watermelon🍉🍉", "Grapes🍇🍇" ]
    @State private var selectedFuel = "Fuel Type"
    @State private var isTapped = false
    
    let haptic = UIImpactFeedbackGenerator(style: .light)
    
    var isDisabled : Bool {
        return carName.isEmpty || brand.isEmpty || model.isEmpty || selectedFuel == "Fuel Type"
    }
    
    var customLabel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36)
                .stroke(isTapped ? Palette.black : Palette.greyInput,lineWidth: 1)
                .background(isTapped ? Palette.greyLight : Palette.greyBackground)
                .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
            HStack{
                Text(selectedFuel)
                    .font(Typography.TextM)
                Spacer()
            }
            .accentColor(isTapped ? Palette.black : Palette.greyInput)
            .padding(.leading,40)
        }
    }
    
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
            VStack(spacing:20){
                
                TextField("Car's name", text: $carName)
                    .disableAutocorrection(true)
                    .focused($focusedField,equals: .carName)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .carName ? Palette.greyLight :Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(RoundedRectangle(cornerRadius: 36)
                        .stroke(focusedField == .carName ? Palette.black :Palette.greyInput, lineWidth: 1))
                    .modifier(ClearButton(text: $carName))
                
                
                TextField("Brand", text: $brand)
                    .disableAutocorrection(true)
                    .focused($focusedField,equals: .brand)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .brand ? Palette.greyLight :Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(RoundedRectangle(cornerRadius: 36)
                        .stroke(focusedField == .brand ? Palette.black :Palette.greyInput, lineWidth: 1))
                    .modifier(ClearButton(text: $brand))
                
                TextField("Model", text: $model)
                    .disableAutocorrection(true)
                    .focused($focusedField,equals: .model)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .model ? Palette.greyLight :Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(RoundedRectangle(cornerRadius: 36)
                        .stroke(focusedField == .model ? Palette.black :Palette.greyInput, lineWidth: 1))
                    .modifier(ClearButton(text: $model))
                
                
                Menu{
                    Picker(selection: $selectedFuel, label:
                            EmptyView()){
                        ForEach(fuelCategories,id: \.self) { name in
                            Text(name)
                        }
                    }
                } label: {
                    customLabel
                }.onTapGesture {
                    isTapped = true
                }
                
            }.padding(.vertical,40)
            Spacer()
            Button(action: {
                withAnimation(.easeInOut){
                    destination = .page3
                }
            }, label: {
                OnBoardingButton(text: "Next", textColor: Palette.white, color: Palette.black)
            })
            .disabled(isDisabled)
            .opacity(isDisabled ? 0.25 : 1)
        }
        .background(Palette.greyBackground)
        .onTapGesture {
            focusedField = nil
        }
    }
    
}

struct Page3 : View {
    var body: some View {
        Text("Page 3")
    }
}

struct Page4 : View {
    
    @Binding var destination : Pages
    
    var body: some View {
        VStack(alignment: .center){

            Spacer()
            VStack(spacing:12){
                Text("Don’t miss anything \n important")
                    .font(Typography.headerXL)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
                Text("Let us remind you key dates about your \nvehicle’s maintenance status and deadlines")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            .padding(.vertical,-70)
            Spacer()
            Image("page4")
                .offset(y:-20)
            Spacer()
            VStack(spacing: 16){
                Button(action: {
                    withAnimation(.easeInOut){
                                        destination = .page5
                    }
                }, label: {
                    OnBoardingButton(text: "Activate notifications", textColor: Palette.white, color: Palette.black)
                })
                Button(action: {
                    withAnimation(.easeInOut){
                                               destination = .page5
                    }
                }, label: {
                    OnBoardingButton(text: "Later", textColor: Palette.black, color: Palette.white)
                })
                
            }
            
        }.background(Palette.greyBackground)
    }
}

struct Page5 : View {
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            Image("page5")
                .offset(y:30)
            Spacer()
            VStack(spacing:12){
                Text("Your vehicle is ready!")
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text("You are set to start your engine and optimize \n your spendings")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }.padding(.vertical,50)
            VStack(spacing: 16){
                Button(action: {
                    withAnimation(.easeInOut){
                        //                        destination = .page5
                    }
                }, label: {
                    OnBoardingButton(text: "Okayyyy let's go", textColor: Palette.white, color: Palette.black)
                })
                Button(action: {
                    withAnimation(.easeInOut){
                        //                        destination = .page2
                    }
                }, label: {
                    OnBoardingButton(text: "Add new car", textColor: Palette.black, color: Palette.white)
                })
            }
            
        }.background(Palette.greyBackground)
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
                        .foregroundColor(Palette.black)
                }
                .padding(.trailing, 20)
            }
        }
    }
}
