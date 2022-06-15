//
//  AlertsOnBoarding.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 19/05/22.
//

import SwiftUI

enum FocusFieldAlertOB: Hashable {
    case numberTitle
    case number
    case odometer
    case plate
}

struct AlertOdometerOB: View {
    
    @StateObject var onboardingVM : OnboardingViewModel
    
    @FocusState var focusedField: FocusFieldAlertOB?
    
    @State private var navigateToDetail = false
    
    var body: some View {
        ZStack{
            Rectangle()
                .cornerRadius(18)
                .foregroundColor(Palette.white)
            VStack{
                HStack{
                    Spacer()
                    Text("Write the odometer")
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                        .padding(.leading,40)
                    Spacer()
                    Button(action: {
                        onboardingVM.showAlertOdometer.toggle()
                        onboardingVM.showOverlay = false
                    }, label: {
                        buttonComponent(iconName: "ics")
                            .foregroundColor(Palette.black)
                            .padding(.trailing,20)
                    })
                    
                }
                VStack(spacing:12){
                    TextField(String(localized: "Previously 0 km"), value: $onboardingVM.vehicle.odometer,formatter: NumberFormatter())
                        .disableAutocorrection(true)
                        .focused($focusedField,equals: .odometer)
                        .keyboardType(.numberPad)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .frame(width: UIScreen.main.bounds.size.width * 0.84, height: UIScreen.main.bounds.size.height * 0.055)
                        .background(Palette.greyLight)
                        .font(Typography.TextM)
                        .foregroundColor(Palette.black)
                        .cornerRadius(36)
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(focusedField == .plate ? Palette.black : Palette.greyInput, lineWidth: 1)
                        )
                    
                    Button(action: {
                        onboardingVM.showAlertOdometer.toggle()
                        onboardingVM.showOverlay = false
                        
                    }, label: {
                        BlackButton(text: "Save",color: onboardingVM.vehicle.odometer < 0 ? Palette.greyInput : Palette.black)
                    })
                    .disabled(onboardingVM.vehicle.odometer < 0)
                    
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.20)
        .onAppear{focusedField = .odometer}
    }
    @ViewBuilder
    func buttonComponent(iconName: String) -> some View {
        ZStack{
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(Palette.greyLight)
            Image(iconName)
        }
    }
}

struct AlertPlateOB: View {
    
    @StateObject var onboardingVM : OnboardingViewModel
    
    @FocusState var focusedField: FocusFieldAlertOB?
    
    @State private var navigateToDetail = false
    
    var body: some View {
        ZStack{
            Rectangle()
                .cornerRadius(18)
                .foregroundColor(Palette.white)
            VStack{
                HStack{
                    Spacer()
                    Text("Write the plate number")
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                        .padding(.leading,40)
                    Spacer()
                    Button(action: {
                        onboardingVM.showAlertPlate.toggle()
                        onboardingVM.showOverlay = false
                    }, label: {
                        buttonComponent(iconName: "ics")
                            .foregroundColor(Palette.black)
                            .padding(.trailing,20)
                    })
                    
                }
                VStack(spacing:12){
                    TextField("Plate number", text: $onboardingVM.vehicle.plate)
                        .disableAutocorrection(true)
                        .focused($focusedField,equals: .plate)
                        .keyboardType(.default)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .frame(width: UIScreen.main.bounds.size.width * 0.84, height: UIScreen.main.bounds.size.height * 0.055)
                        .background(Palette.greyLight)
                        .font(Typography.TextM)
                        .foregroundColor(Palette.black)
                        .cornerRadius(36)
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(focusedField == .plate ? Palette.black : Palette.greyInput, lineWidth: 1)
                        )
            
                    Button(action: {
                        onboardingVM.showAlertPlate.toggle()
                        onboardingVM.showOverlay = false
                        
                    }, label: {
                        BlackButton(text: "Save",color: onboardingVM.vehicle.plate.isEmpty ? Palette.greyInput : Palette.black)
                    })
                    .disabled(onboardingVM.vehicle.plate.isEmpty)
                    
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.20)
        .onAppear{focusedField = .plate}
    }
    @ViewBuilder
    func buttonComponent(iconName: String) -> some View {
        ZStack{
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(Palette.greyLight)
            Image(iconName)
        }
    }
}

struct AlertImportantNumbersOB: View {
    
    @StateObject var onboardingVM : OnboardingViewModel
    
    @FocusState var focusedField: FocusFieldAlertOB?
    
    @State private var navigateToDetail = false
    
    var body: some View {
        ZStack{
            Rectangle()
                .cornerRadius(18)
                .foregroundColor(Palette.white)
            VStack{
                HStack{
                    Spacer()
                    Text("Add useful contacts")
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                        .padding(.leading,40)
                    Spacer()
                    Button(action: {
                        onboardingVM.showAlertImportantNumbers.toggle()
                        onboardingVM.showOverlay = false
                    }, label: {
                        buttonComponent(iconName: "ics")                .foregroundColor(Palette.black)
                            .padding(.trailing,20)
                    })
                    
                }
                VStack(spacing:12){
                    TextField("Contact name", value: $onboardingVM.vehicle.odometer,formatter: NumberFormatter())
                        .disableAutocorrection(true)
                        .focused($focusedField,equals: .numberTitle)
                        .keyboardType(.numberPad)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .frame(width: UIScreen.main.bounds.size.width * 0.84, height: UIScreen.main.bounds.size.height * 0.055)
                        .background(Palette.greyLight)
                        .font(Typography.TextM)
                        .foregroundColor(Palette.black)
                        .cornerRadius(36)
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(focusedField == .numberTitle ? Palette.black : Palette.greyInput, lineWidth: 1)
                        )
                        .onSubmit {
                            focusedField = .number
                        }
                    
                    TextField("Number", value: $onboardingVM.vehicle.odometer,formatter: NumberFormatter())
                        .disableAutocorrection(true)
                        .focused($focusedField,equals: .number)
                        .keyboardType(.numberPad)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .frame(width: UIScreen.main.bounds.size.width * 0.84, height: UIScreen.main.bounds.size.height * 0.055)
                        .background(Palette.greyLight)
                        .font(Typography.TextM)
                        .foregroundColor(Palette.black)
                        .cornerRadius(36)
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(focusedField == .number ? Palette.black : Palette.greyInput, lineWidth: 1)
                        )
                    
                    Button(action: {
                        onboardingVM.showAlertImportantNumbers.toggle()
                        onboardingVM.showOverlay = false
                        
                    }, label: {
                        BlackButton(text: "Save",color: onboardingVM.vehicle.odometer < 0 ? Palette.greyInput : Palette.black)
                    })
                    .disabled(onboardingVM.vehicle.odometer < 0)
                    
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.28)
        .onAppear{focusedField = .numberTitle}
    }
    @ViewBuilder
    func buttonComponent(iconName: String) -> some View {
        ZStack{
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(Palette.greyLight)
            Image(iconName)
        }
    }
}

