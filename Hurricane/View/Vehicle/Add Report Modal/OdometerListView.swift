//
//  OdometerListView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import SwiftUI

struct OdometerListView: View {
    
    @StateObject var addExpVM : AddExpenseViewModel
    @ObservedObject var utilityVM : UtilityViewModel
    var focusedField : FocusState<FocusField?>.Binding
    
    var body: some View {
        List{
            
            //MARK: DATE
            DatePicker(selection: $addExpVM.date, displayedComponents: [.date]) {
                ListCategoryComponent(title: String(localized: "Day"), iconName: "day", color: Palette.colorGreen)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            //MARK: NOTE
            HStack{
                ZStack{
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundColor(addExpVM.note.isEmpty ? Palette.greyLight : Palette.colorViolet)
                    Image(addExpVM.note.isEmpty ? "note" : "noteColored")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                TextField(String(localized: "Note"),text: $addExpVM.note)
                    .disableAutocorrection(true)
                    .focused(focusedField, equals: .note)
                    .font(Typography.headerM)
                
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        }
        .padding(.top,-10)
        .onAppear {
            /// Setting the keyboard focus on the price when opening the modal
            if(addExpVM.odometer.isEmpty){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {  /// Anything over 0.5 delay seems to work
                    focusedField.wrappedValue = .odometerTab
                }
            }
        }
    }
}
