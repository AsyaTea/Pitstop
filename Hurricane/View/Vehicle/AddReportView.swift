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
    
    @State private var selectedRepeat = "Never"
    let repeatTypes = ["Never", "Daily", "Weekdays","Weekends", "Weekly","Monthly","Every 3 Months","Every 6 Months","Yearly"]
    
    @State private var selectedFuelType = "Default"
    let fuelTypes = ["Default", "Secondary"]
    
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
                    //MARK: LIST
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
                    
                    //MARK: ODOMETER
                    HStack{
                        ListCategoryComponent(title: "Odometer", iconName: "odometer", color: Palette.colorBlue)
                        Spacer()
                        TextField("100",text: $odometer)
                            .font(Typography.headerM)
                            .focused($focusedField,equals: .odometer)
                            .foregroundColor(Palette.black)
                            .textFieldStyle(.plain)
                            .keyboardType(.decimalPad)
                            .fixedSize(horizontal: true, vertical: true)
                        Text(unit)
                            .font(Typography.headerM)
                            .foregroundColor(Palette.black)
                    }
                    
                    //MARK: FUEL TYPE
                    Picker(selection: $selectedFuelType, content: {
                        ForEach(fuelTypes, id: \.self) {
                            Text($0)
                                .font(Typography.headerM)
                        }
                    }, label:{
                        ListCategoryComponent(title: "Fuel type", iconName: "fuelType", color: Palette.colorOrange)
                    })
                    
                    
                    //MARK: REPEAT PICKER
                    Picker(selection: $selectedRepeat, content: {
                        ForEach(repeatTypes, id: \.self) {
                            Text($0)
                                .font(Typography.headerM)
                        }
                    }, label:{
                        ListCategoryComponent(title: "Repeat", iconName: "repeat", color: Palette.colorViolet)
                    })
                    
                    //MARK: DATE PICKER
                    DatePicker(selection: $date, displayedComponents: [.date]) {
                        
                        ListCategoryComponent(title: "Day", iconName: "day", color: Palette.colorGreen)
                        
                    }
                    //MARK: NOTE
                    HStack{
                        ZStack{
                            Circle()
                                .frame(width: 32, height: 32)
                                .foregroundColor(Palette.greyLight)
                            Image("note")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        TextField("Note",text: $note)
                            .disableAutocorrection(true)
                            .font(Typography.headerM)
                            .focused($focusedField,equals: .note)
                    }
                    
                }
                    .padding(.top,-10)
                }
                else if (utilityVM.currentPickerTab == "Odometer"){
                    Text("Odometer")
                    Spacer()
                }
                else{
                    Text("Reminder")
                    Spacer()
                }
                
                //                Button("Save"){
                //                    presentationMode.wrappedValue.dismiss()
                //                }
                //                .buttonStyle(SaveButton())
                //                .disabled(price.isEmpty)
                //                .opacity(price.isEmpty ? 0.6 : 1)
                
                
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
                    .disabled(priceTab.isEmpty)
                    .opacity(priceTab.isEmpty ? 0.6 : 1)
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
                        if (focusedField == .note){
                            Button("Save") {
                                presentationMode.wrappedValue.dismiss()
                            }.disabled(priceTab.isEmpty)
                        }
                        if (focusedField == .odometer){
                            Button("Next") {
                                focusedField = .note
                            }
                        }
                        if (focusedField == .priceTab){
                            Button("Next") {
                                focusedField = .odometer
                            }
                        }
                        
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("New report")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
            .onAppear {
                /// Setting the keyboard focus on the price when opening the modal
                if(priceTab.isEmpty){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {  /// Anything over 0.5 delay seems to work
                        self.focusedField = .priceTab
                    }
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
            odometer = ""
            note = ""
        }
        if(tab == "Odometer"){
            odometerTab = ""
//            note = ""
        }
        if(tab == "Reminder"){
            reminderTab = ""
//            note = ""
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
                .onSubmit {
                    focusedField.wrappedValue = .odometer
                }
            
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
    case odometer
    case note
}
