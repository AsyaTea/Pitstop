//
//  AlertAddNumbers.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 14/05/22.
//

import SwiftUI

enum FocusFieldAlert: Hashable {
    case numberTitle
    case number

}

struct AlertAddNumbers: View {
    
    @State  var numberTitle : String
    @State  var number : String
    @FocusState var focusedField: FocusFieldAlert?
    
    var isDisabled : Bool {
        return numberTitle.isEmpty || number.isEmpty
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .cornerRadius(18)
                .foregroundColor(Palette.white)
            VStack{
            HStack{
                Spacer()
                Text("Add important numbers")
                    .foregroundColor(Palette.black)
                    .font(Typography.headerM)
                    .padding(.leading,40)
                Spacer()
                Button(action: {
                    
                }, label: {
                    buttonComponent(iconName: "plus")
                        .padding(.trailing,20)
                })
               
            }
                VStack(spacing:12){
                TextField("Number title", text: $numberTitle)
                    .disableAutocorrection(true)
                    .focused($focusedField,equals: .numberTitle)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.84, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(Palette.greyLight )
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(Palette.greyInput, lineWidth: 1)
                    )
                    .onSubmit {
                        focusedField = .number
                    }
                
                TextField("Number", text: $number)
                    .disableAutocorrection(true)
                    .focused($focusedField,equals: .number)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.84, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(Palette.greyLight )
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(Palette.greyInput, lineWidth: 1)
                    )
                    .onSubmit {
//                        focusedField = .brand
                    }
                
                Button(action: {
                    
                }, label: {
                    BlackButton(text: "Save")
                })
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.6 : 1)
                
                }
            }
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.26)
    }
    @ViewBuilder
    func buttonComponent(iconName: String) -> some View {
        ZStack{
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(Palette.greyMiddle)
            Image(iconName)
        }
    }
}


struct AlertAddNumbers_Previews: PreviewProvider {
    static var previews: some View {
        AlertAddNumbers(numberTitle: "", number: "")
           
    }
}


struct BlackButton : View {
    
    var text : String
    var body: some View {
        
        ZStack{
            Rectangle()
                .cornerRadius(36)
                .foregroundColor(Palette.black)
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

