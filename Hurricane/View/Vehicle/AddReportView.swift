//
//  AddReportView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct AddReportView: View {
    
    init() {
        //  Change list background color
        UITableView.appearance().separatorStyle = .none
        //       UITableViewCell.appearance().backgroundColor = .green
        UITableView.appearance().backgroundColor = UIColor(Palette.greyBackground)

    }
    
    @StateObject var utilityVM : UtilityViewModel = .init()
    
    //MARK: TODO COLLEGARE VAR
    
    //Text fields vars
    @State private var priceTab : String = ""
    var currency = "$"
    @State private var odometer : String = "" ///Var  to store the odometer value in expense
    var unit = "km"
    @State private var note : String = ""
    
    @State private var odometerTab : String = ""  /// Var to store the odometer value in odometer tab
    
    @State private var reminderTab : String = "" /// Var to store the reminder title in reminder tab
    
    @State private var liters : String = ""
    @State private var pricePerLiter : String = ""
    
    
    //Date
    @State private var date = Date()
    @State private var showDate = false
    private var dateFormater: DateFormatter {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        return dateFormater
    }
    
    @State var calendarId: UUID = UUID()
    
    //Custom picker tabs
    @State private var pickerTabs = ["Expense", "Odometer", "Reminder"]
    
    //List picker categories
    @State private var selectedCategory = "Fuel"
    let categoryTypes = ["Fuel", "Maintenance", "Insurance","Road tax","Tolls","Fines","Parking","Other"]
    
    @State private var selectedCategoryReminder =  "Maintenance"
    let categoryReminder = ["Maintenance", "Insurance","Road tax","Tolls","Parking","Other"]
    
    @State private var selectedRepeat = "Never"
    let repeatTypes = ["Never", "Daily", "Weekdays","Weekends", "Weekly","Monthly","Every 3 Months","Every 6 Months","Yearly"]
    
    @State private var selectedFuelType = "Default"
    let fuelTypes = ["Default", "Secondary"]
    
    @State private var selectedBased = "Date"
    let basedTypes = ["Date","Distance"]
    
    //Matching geometry namespace
    @Namespace var animation
    
    //Focusn keyboard
    @FocusState var focusedField: FocusField?
    
    //To dismiss the modal
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView{
            VStack {
                
                //MARK: Custom TextField
                if(utilityVM.currentPickerTab == "Expense"){
                    TextFieldComponent(submitField: $priceTab, placeholder: "42", attribute: currency, keyboardType: .numberPad,focusedField: $focusedField, defaultFocus: .priceTab)
                        .padding(.top,15)
                }
                else if (utilityVM.currentPickerTab == "Odometer"){
                    TextFieldComponent(submitField: $odometerTab, placeholder: "100", attribute: unit, keyboardType: .numberPad,focusedField: $focusedField,defaultFocus: .odometerTab)
                        .padding(.top,15)
                }
                else{
                    TextFieldComponent(submitField: $reminderTab, placeholder: "-", attribute: "ㅤ", keyboardType: .default,focusedField: $focusedField,defaultFocus: .reminderTab)
                        .padding(.top,15)
                }
                
                
                //MARK: Custom segmented picker
                CustomSegmentedPicker()
                    .padding(.horizontal,32)
                    .padding(.top, -10.0)
                
                
                if(utilityVM.currentPickerTab == "Expense"){
                    //MARK: Expense List
                    List{
                        //MARK: CATEGORY PICKER
                        Picker(selection: $selectedCategory, content: {
                            ForEach(categoryTypes, id: \.self) {
                                Text($0)
                                    .font(Typography.headerM)
                            }
                        },label:{
                            ListCategoryComponent(title: "Category", iconName: "category", color: Palette.colorYellow)
                        })
                        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        
                        //MARK: ODOMETER
                        HStack{
                            ListCategoryComponent(title: "Odometer", iconName: "odometer", color: Palette.colorBlue)
                            Spacer()
                            TextField("100",text: $odometer)
                                .font(Typography.headerM)
                                .foregroundColor(Palette.black)
                                .keyboardType(.decimalPad)
                                .fixedSize(horizontal: true, vertical: true)
                            Text(unit)
                                .font(Typography.headerM)
                                .foregroundColor(Palette.black)
                        }
                        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        
                        
                        //MARK: FUEL TYPE
                        if(selectedCategory == "Fuel"){
                            Picker(selection: $selectedFuelType, content: {
                                ForEach(fuelTypes, id: \.self) {
                                    Text($0)
                                        .font(Typography.headerM)
                                }
                            }, label:{
                                ListCategoryComponent(title: "Fuel type", iconName: "fuelType", color: Palette.colorOrange)
                            })
                            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        }
                        
                        //MARK: DATE PICKER
                        DatePicker(selection: $date, displayedComponents: [.date]) {
                            
                            ListCategoryComponent(title: "Day", iconName: "day", color: Palette.colorGreen)
                            
                        }
                        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        
                        //MARK: LITERS & PRICE/LITER
                        if(selectedCategory == "Fuel"){
                            HStack{
                                ZStack{
                                    Circle()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(liters.isEmpty ? Palette.greyLight : Palette.colorOrange)
                                    Image(liters.isEmpty ? "liters" : "literColored")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                }
                                Text("Liters")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.headerM)
                                Spacer()
                                TextField("20",text: $liters)
                                    .disableAutocorrection(true)
                                    .keyboardType(.numberPad)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .font(Typography.headerM)
                                Text("L")
                                    .font(Typography.headerM)
                                    .foregroundColor(Palette.black)
                            }
                            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                            
                            
                            HStack{
                                ZStack{
                                    Circle()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(pricePerLiter.isEmpty ? Palette.greyLight : Palette.colorYellow)
                                    Image(pricePerLiter.isEmpty ?  "priceLiter" : "priceLiterColored")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                }
                                Text("Price/Liter")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.headerM)
                                Spacer()
                                TextField("1.70",text: $pricePerLiter)
                                    .disableAutocorrection(true)
                                    .fixedSize(horizontal: true, vertical: true)
                                    .keyboardType(.numberPad)
                                    .font(Typography.headerM)
                                    
                                Text(currency)
                                    .foregroundColor(Palette.black)
                            }
                            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        }
                        
                        //MARK: NOTE
                        HStack{
                            ZStack{
                                Circle()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(note.isEmpty ? Palette.greyLight : Palette.colorViolet)
                                Image(note.isEmpty ? "note" : "noteColored")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                            }
                            TextField("Note",text: $note)
                                .disableAutocorrection(true)
                                .font(Typography.headerM)
                               
                        }
                        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                    }
                    .padding(.top,-10)
                    .onAppear {
                        /// Setting the keyboard focus on the price when opening the modal
                        if(priceTab.isEmpty){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {  /// Anything over 0.5 delay seems to work
                                self.focusedField = .priceTab
                            }
                        }
                    }
                }
                else if (utilityVM.currentPickerTab == "Odometer"){
                    List{
                        DatePicker(selection: $date, displayedComponents: [.date]) {
                            ListCategoryComponent(title: "Day", iconName: "day", color: Palette.colorGreen)
                        }
                        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        
                        HStack{
                            ZStack{
                                Circle()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(note.isEmpty ? Palette.greyLight : Palette.colorViolet)
                                Image(note.isEmpty ? "note" : "noteColored")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                            }
                            TextField("Note",text: $note)
                                .disableAutocorrection(true)
                                .font(Typography.headerM)
                                
                        }
                        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                    }
                    .padding(.top,-10)
                    .onAppear {
                        /// Setting the keyboard focus on the price when opening the modal
                        if(odometerTab.isEmpty){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {  /// Anything over 0.5 delay seems to work
                                self.focusedField = .odometerTab
                            }
                        }
                    }
                }
                else{
                    List{
                        Picker(selection: $selectedCategoryReminder, content: {
                            ForEach(categoryReminder, id: \.self) {
                                Text($0)
                                    .font(Typography.headerM)
                            }
                        },label:{
                            ListCategoryComponent(title: "Category", iconName: "category", color: Palette.colorYellow)
                        })
                        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        
                        //MARK: BASED ON PICKER
                        Picker(selection: $selectedBased, content: {
                            ForEach(basedTypes, id: \.self) {
                                Text($0)
                                    .font(Typography.headerM)
                            }
                        },label:{
                            ListCategoryComponent(title: "Based on", iconName: "basedOn", color: Palette.colorOrange)
                        })
                        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        
                        //MARK: REMIND DATE
                        if (selectedBased == "Date"){
                            DatePicker(selection: $date, displayedComponents: [.date]) {
                                ListCategoryComponent(title: "Remind me on", iconName: "remindMe", color: Palette.colorGreen)
                            }
                            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        }
                        //MARK: REMIND DISTANCE
                        else{
                            HStack{
                                ListCategoryComponent(title: "Remind me in", iconName: "remindMe", color: Palette.colorGreen)
                                Spacer()
                                TextField("1000",text: $odometer)
                                    .font(Typography.headerM)
                                    .foregroundColor(Palette.black)
                                    .textFieldStyle(.plain)
                                    .keyboardType(.decimalPad)
                                    .fixedSize(horizontal: true, vertical: true)
                                Text(unit)
                                    .font(Typography.headerM)
                                    .foregroundColor(Palette.black)
                            }
                            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        }
                        
                        Picker(selection: $selectedRepeat, content: {
                            ForEach(repeatTypes, id: \.self) {
                                Text($0)
                                    .font(Typography.headerM)
                            }
                        }, label:{
                            ListCategoryComponent(title: "Repeat", iconName: "repeat", color: Palette.colorViolet)
                        })
                        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        
                        HStack{
                            ZStack{
                                Circle()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(note.isEmpty ? Palette.greyLight : Palette.colorViolet)
                                Image(note.isEmpty ? "note" : "noteColored")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                            }
                            TextField("Note",text: $note)
                                .disableAutocorrection(true)
                                .font(Typography.headerM)
                        }
                        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                    }
                    .padding(.top,-10)
                    .onAppear {
                        /// Setting the keyboard focus on the price when opening the modal
                        if(reminderTab.isEmpty){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {  /// Anything over 0.5 delay seems to work
                                self.focusedField = .reminderTab
                            }
                        }
                    }
                }
            }
            .background(Palette.greyBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack{
                            Image(systemName: "chevron.left")
                            Text("Cancel")
                                .font(Typography.headerM)
                        }
                    })
                    .accentColor(Palette.greyHard),
                trailing:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                            .font(Typography.headerM)
                    }
                          )
                    .disabled(priceTab.isEmpty && odometerTab.isEmpty && reminderTab.isEmpty)
                    .opacity(priceTab.isEmpty && odometerTab.isEmpty && reminderTab.isEmpty ? 0.6 : 1)
                    .accentColor(Palette.greyHard)
            )
            .toolbar {
                /// Keyboard focus
                ToolbarItem(placement: .keyboard) {
                    HStack{
                        Button("Dismiss") {
                            focusedField = nil
                        }
                        Spacer()
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("New report")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
        }
    }
    
    @ViewBuilder
    func CustomSegmentedPicker() -> some View{
        HStack(spacing:10){
            ForEach(pickerTabs,id:\.self){ tab in
                Text(tab)
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .font(Typography.headerS)
                    .foregroundColor(Palette.black)
                    .background{
                        if utilityVM.currentPickerTab == tab {
                            Capsule()
                                .fill(Palette.greyLight)
                                .matchedGeometryEffect(id: "pickerTab", in: animation)
                        }
                    }
                    .containerShape(Capsule())
                    .onTapGesture {
                        withAnimation(.easeInOut){
                            resetTabFields(tab: utilityVM.currentPickerTab)
                            utilityVM.currentPickerTab = tab
                            let haptic = UIImpactFeedbackGenerator(style: .soft)
                            haptic.impactOccurred()
                        }
                    }
            }
        }
    }
    
    func resetTabFields(tab : String){
        if(tab == "Expense"){
            priceTab = ""
            selectedCategory = "Fuel"
            odometer = ""
            selectedFuelType = "Default"
            selectedRepeat = "Never"
            date = Date.now
            note = ""
        }
        if(tab == "Odometer"){
            odometerTab = ""
            note = ""
            date = Date.now
        }
        if(tab == "Reminder"){
            reminderTab = ""
            note = ""
            date = Date.now
        }
    }
    
}

struct AddReportView_Previews: PreviewProvider {
    static var previews: some View {
        AddReportView()
    }
}



struct SaveButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055, alignment: .center)
            .background(Palette.black)
            .foregroundColor(Palette.white)
            .clipShape(Rectangle())
            .cornerRadius(43)
        
    }
}

struct ListCategoryComponent: View {
    
    var title : String
    var iconName : String
    var color : Color
    
    var body: some View {
        HStack{
            ZStack{
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(color)
                Image(iconName)
                    .resizable()
                    .frame(width: 16, height: 16)
                
            }
            Text(title)
                .font(Typography.headerM)
        }
    }
}

struct TextFieldComponent: View {
    
    @Binding var submitField : String
    var placeholder : String
    var attribute : String
    var keyboardType : UIKeyboardType
    
    var focusedField : FocusState<FocusField?>.Binding
    var defaultFocus : FocusField
    
    var body: some View {
        HStack{
            Spacer()
            TextField(placeholder,text: $submitField)
                .focused(focusedField, equals: defaultFocus)
                .font(Typography.headerXXL)
                .foregroundColor(Palette.black)
                .keyboardType(keyboardType)
                .fixedSize(horizontal: true, vertical: true)
            
            Text(attribute)
                .font(Typography.headerXXL)
                .foregroundColor(Palette.black)
            Spacer()
        }
    }
}

enum FocusField: Hashable {
    case priceTab
    case odometerTab
    case reminderTab

}
