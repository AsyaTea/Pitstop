//
//  ReminderListView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import SwiftUI

struct ReminderListView: View {
    
    @ObservedObject var addExpVM : AddExpenseViewModel
    @ObservedObject var utilityVM : UtilityViewModel
    var focusedField : FocusState<FocusField?>.Binding
    
    var body: some View {
        List{
            
            //MARK: CATEGORY
            Picker(selection: $addExpVM.selectedCategoryReminder, content: {
                ForEach(addExpVM.categoryReminder, id: \.self) {
                    Text($0)
                        .font(Typography.headerM)
                }
            },label:{
                ListCategoryComponent(title: "Category", iconName: "category", color: Palette.colorYellow)
            })
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            //MARK: BASED ON PICKER
            Picker(selection: $addExpVM.selectedBased, content: {
                ForEach(addExpVM.basedTypes, id: \.self) {
                    Text($0)
                        .font(Typography.headerM)
                }
            },label:{
                ListCategoryComponent(title: "Based on", iconName: "basedOn", color: Palette.colorOrange)
            })
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            //MARK: REMIND DATE
            if (addExpVM.selectedBased == "Date"){
                DatePicker(selection: $addExpVM.date, displayedComponents: [.date]) {
                    ListCategoryComponent(title: "Remind me on", iconName: "remindMe", color: Palette.colorGreen)
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            }
            //MARK: REMIND DISTANCE
            else{
                HStack{
                    ListCategoryComponent(title: "Remind me in", iconName: "remindMe", color: Palette.colorGreen)
                    Spacer()
                    TextField("1000",value: $addExpVM.odometer,formatter: NumberFormatter())
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                        .textFieldStyle(.plain)
                        .keyboardType(.decimalPad)
                        .fixedSize(horizontal: true, vertical: true)
                    Text(utilityVM.unit)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            }
            //MARK: REPEAT
            Picker(selection: $addExpVM.selectedRepeat, content: {
                ForEach(addExpVM.repeatTypes, id: \.self) {
                    Text($0)
                        .font(Typography.headerM)
                }
            }, label:{
                ListCategoryComponent(title: "Repeat", iconName: "repeat", color: Palette.colorViolet)
            })
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
                TextField("Note",text: $addExpVM.note)
                    .disableAutocorrection(true)
                    .focused(focusedField, equals: .note)
                    .font(Typography.headerM)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        }
        .padding(.top,-10)
        .onAppear {
            /// Setting the keyboard focus on the price when opening the modal
            if(addExpVM.reminderTab.isEmpty){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {  /// Anything over 0.5 delay seems to work
                    focusedField.wrappedValue = .reminderTab
                }
            }
        }
    }
}
