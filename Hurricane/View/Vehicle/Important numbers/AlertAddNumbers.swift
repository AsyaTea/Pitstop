//
//  AlertAddNumbers.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 14/05/22.
//

import SwiftUI

enum FocusFieldNumbers: Hashable {
    case numberTitle
    case number
    
}

struct AlertAddNumbers: View {
    
    @StateObject var homeVM : HomeViewModel
    @ObservedObject var dataVM: DataViewModel
    
    @FocusState var focusedField: FocusFieldNumbers?
    
    @State private var navigateToDetail = false
    
    var body: some View {
        ZStack{
            Rectangle()
                .cornerRadius(18)
                .foregroundColor(Palette.white)
            VStack{
                HStack{
                    Spacer()
                    Text(String(localized: "Add useful contact"))
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                        .padding(.leading,40)
                    Spacer()
                    Button(action: {
                        homeVM.resetAlertFields()
                    }, label: {
                        buttonComponent(iconName: "plus")
                            .padding(.trailing,20)
                    })
                    
                }
                VStack(spacing:12){
                    TextField(String(localized: "Contact name"), text: $homeVM.numberTitle)
                        .disableAutocorrection(true)
                        .focused($focusedField,equals: .numberTitle)
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
                    
                    TextField(String(localized: "Number"), text: $homeVM.number)
                        .disableAutocorrection(true)
                        .focused($focusedField,equals: .number)
                        .keyboardType(.phonePad)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .frame(width: UIScreen.main.bounds.size.width * 0.84, height: UIScreen.main.bounds.size.height * 0.055)
                        .background(Palette.greyLight )
                        .font(Typography.TextM)
                        .foregroundColor(Palette.black)
                        .cornerRadius(36)
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(focusedField == .number ? Palette.black : Palette.greyInput, lineWidth: 1)
                        )
                        .onSubmit {
                            focusedField = .number
                        }
                    
                    Button(action: {
                        homeVM.createNumber()
                        dataVM.addNumber(number: homeVM.numberS)
                        navigateToDetail.toggle()
                        
                    }, label: {
                        BlackButton(text: "Save",color: homeVM.isDisabled ? Palette.greyInput : Palette.black)
                    })
                    .disabled(homeVM.isDisabled)
                    
                }
            }
        }
        .sheet(isPresented: $navigateToDetail,onDismiss: homeVM.resetAlertFields){ImportantNumbersView(homeVM: homeVM,dataVM: dataVM)}
        .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.28)
        .onAppear{focusedField = .numberTitle}
    }
    @ViewBuilder
    func buttonComponent(iconName: String) -> some View {
        ZStack{
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(Palette.greyLight)
            Image("ics")
                .foregroundColor(Palette.black)

        }
    }
}


//struct AlertAddNumbers_Previews: PreviewProvider {
//    static var previews: some View {
//        AlertAddNumbers(numberTitle: "", number: "")
//
//    }
//}


struct BlackButton : View {
    
    var text : LocalizedStringKey
    var color : Color
    
    var body: some View {
        
        ZStack{
            Rectangle()
                .cornerRadius(36)
                .foregroundColor(color)
            HStack{
                Spacer()
                Text(text)
                    .foregroundColor(Palette.white)
                    .font(Typography.headerM)
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.size.width * 0.84, height: UIScreen.main.bounds.size.height * 0.055, alignment: .center)
    }
}

struct AlertAddNumbersInside: View {
    
    @ObservedObject var homeVM : HomeViewModel
    @ObservedObject var dataVM : DataViewModel
    
    @FocusState var focusedField: FocusFieldNumbers?
    
    @State private var navigateToDetail = false
    
    var body: some View {
        ZStack{
            Rectangle()
                .cornerRadius(18)
                .foregroundColor(Palette.white)
            VStack{
                HStack{
                    Spacer()
                    Text(String(localized: "Add useful contact"))
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                        .padding(.leading,40)
                    Spacer()
                    Button(action: {
                        homeVM.resetAlertFieldsInside()
                    }, label: {
                        buttonComponent(iconName: "plus")
                            .padding(.trailing,20)
                    })
                    
                }
                VStack(spacing:12){
                    TextField(String(localized: "Contact name"), text: $homeVM.numberTitle)
                        .disableAutocorrection(true)
                        .focused($focusedField,equals: .numberTitle)
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
                    
                    TextField(String(localized: "Number"), text: $homeVM.number)
                        .disableAutocorrection(true)
                        .focused($focusedField,equals: .number)
                        .keyboardType(.phonePad)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .frame(width: UIScreen.main.bounds.size.width * 0.84, height: UIScreen.main.bounds.size.height * 0.055)
                        .background(Palette.greyLight )
                        .font(Typography.TextM)
                        .foregroundColor(Palette.black)
                        .cornerRadius(36)
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(focusedField == .number ? Palette.black : Palette.greyInput, lineWidth: 1)
                        )
                        .onSubmit {
                            focusedField = .number
                        }
                    
                    Button(action: {
                        //Dismiss the alert when saving
                        homeVM.createNumber()
                        dataVM.addNumber(number: homeVM.numberS)
                        homeVM.interactiveDismiss.toggle()
                        homeVM.resetAlertFieldsInside()
                    }, label: {
                        BlackButton(text: "Save",color: homeVM.isDisabled ? Palette.greyInput : Palette.black)
                    })
                    .disabled(homeVM.isDisabled)
                    
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.28)
        .onAppear{
            homeVM.number = ""
            homeVM.numberTitle = ""
            focusedField = .numberTitle
        }
    }
    @ViewBuilder
    func buttonComponent(iconName: String) -> some View {
        ZStack{
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(Palette.greyLight)
            Image("ics")
                .foregroundColor(Palette.black)
        }
    }
}
