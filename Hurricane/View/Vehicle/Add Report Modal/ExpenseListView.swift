//
//  ExpenseListView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import SwiftUI

struct ExpenseListView: View {
    
    @StateObject var addExpVM : AddExpenseViewModel
    @ObservedObject var utilityVM : UtilityViewModel
    @ObservedObject var dataVM : DataViewModel
    @ObservedObject var categoryVM : CategoryViewModel
    @StateObject var fuelVM = FuelViewModel()
    @StateObject var reminderVM : AddReminderViewModel
    
    var focusedField : FocusState<FocusField?>.Binding
       
    @State var selectedItem: Category = .fuel
    @State private var checkmark1 = true
    @State private var checkmark2 = false
    
    var body: some View {
        
        List{
     
            //MARK: CUSTOM CATEGORY PICKER
            HStack{
                ListCategoryComponent(title: String(localized: "Category"), iconName: "category", color: Palette.colorYellow)
                Spacer()
                NavigationLink(destination: CustomCategoryPicker(dataVM: dataVM, addExpVM: addExpVM, reminderVM: reminderVM, categoryVM: categoryVM, selectedItem: $selectedItem)){
                Spacer()
                Text(addExpVM.selectedCategory)
                    .fixedSize()
                    .font(Typography.headerM)
                    .foregroundColor(Palette.greyMiddle)
                }
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            //MARK: ODOMETER
            HStack{
                ListCategoryComponent(title: String(localized: "Odometer"), iconName: "odometer", color: Palette.colorBlue)
                Spacer()
                TextField(String(Int(dataVM.currentVehicle.first?.odometer ?? 0)), text: $addExpVM.odometer)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .focused(focusedField, equals: .odometer)
                    .keyboardType(.decimalPad)
                    .fixedSize(horizontal: true, vertical: true)
                Text(utilityVM.unit)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField.wrappedValue = .odometer
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            
            //MARK: FUEL TYPE
            if(addExpVM.selectedCategory == NSLocalizedString("Fuel", comment: "")){
                HStack{
                    ListCategoryComponent(title: String(localized: "Fuel type"), iconName: "fuelType", color: Palette.colorOrange)
                    Spacer()
                    NavigationLink(destination: CustomFuelPicker(dataVM: dataVM,addExpVM: addExpVM, fuelVM: fuelVM, checkmark1: $checkmark1,checkmark2: $checkmark2)){
                        Spacer()
                        Text(addExpVM.selectedFuel)
                            .fixedSize()
                            .font(Typography.headerM)
                            .foregroundColor(Palette.greyMiddle)
                    }
                }.listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            }
            
            //MARK: DATE PICKER
            DatePicker(selection: $addExpVM.expenseS.date,in: ...Date(), displayedComponents: [.date]) {
                ListCategoryComponent(title: String(localized: "Day"), iconName: "day", color: Palette.colorGreen)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            //MARK: LITERS & PRICE/LITER
            if(addExpVM.selectedCategory == NSLocalizedString("Fuel", comment: "")){
                HStack{
                    ZStack{
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundColor(addExpVM.liters.isEmpty ? Palette.greyLight : Palette.colorOrange)
                        Image(addExpVM.liters.isEmpty ? "liters" : "literColored")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    Text(String(localized: "Liters"))
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                    Spacer()
                    TextField("0",text: $addExpVM.liters)
                        .disableAutocorrection(true)
                        .keyboardType(.decimalPad)
                        .focused(focusedField, equals: .liter)
                        .fixedSize(horizontal: true, vertical: true)
                        .font(Typography.headerM)
    
                    Text("L")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField.wrappedValue = .liter
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                
                
                HStack{
                    ZStack{
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundColor(addExpVM.pricePerLiter.isEmpty ? Palette.greyLight : Palette.colorYellow)
                        Image(addExpVM.pricePerLiter.isEmpty ?  "priceLiter" : "priceLiterColored")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    Text(String(localized: "Price/Liter"))
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                    Spacer()
                    TextField("0",text: $addExpVM.pricePerLiter)
                        .disableAutocorrection(true)
                        .focused(focusedField, equals: .priceLiter)
                        .fixedSize(horizontal: true, vertical: true)
                        .keyboardType(.decimalPad)
                        .font(Typography.headerM)
                    
                    Text(utilityVM.currency)
                        .foregroundColor(Palette.black)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField.wrappedValue = .priceLiter
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            }
            
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
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField.wrappedValue = .note
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        }
        .padding(.top,-5)
        .onAppear {
            /// Setting the keyboard focus on the price when opening the modal
            if(addExpVM.priceTab.isEmpty){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {  /// Anything over 0.5 delay seems to work
                    focusedField.wrappedValue = .priceTab
                }
            }
         
            if(addExpVM.selectedFuel == ""){
                addExpVM.selectedFuel = dataVM.currentVehicle.first?.fuelTypeOne.label ?? ""
                fuelVM.defaultFuelType = dataVM.currentVehicle.first?.fuelTypeOne ?? FuelType.none
                addExpVM.fuel = fuelVM.defaultSelectedFuel
            }
        }
    }
}

//struct ExpenseListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpenseListView()
//    }
//}


struct CustomFuelPicker : View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var dataVM : DataViewModel
    @StateObject var addExpVM : AddExpenseViewModel
    @StateObject var fuelVM : FuelViewModel
    @Binding var checkmark1 : Bool
    @Binding var checkmark2 : Bool
    
    var body: some View {
        List{
            Button(action: {
                withAnimation(.easeOut) {
                    checkmark1 = true
                    checkmark2 = false
                    addExpVM.selectedFuel = dataVM.currentVehicle.first?.fuelTypeOne.label ?? ""
                    fuelVM.defaultFuelType = dataVM.currentVehicle.first?.fuelTypeOne ?? FuelType.none
                    addExpVM.fuel = fuelVM.defaultSelectedFuel
                    
//                    addExpVM.expenseS.fuelType = fuelVM.defaultSelectedFuel
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                HStack {
                    Text(dataVM.currentVehicle.first?.fuelTypeOne.label ?? "")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                        .opacity(checkmark1 ? 1.0 : 0.0)
                }
            }
            if(dataVM.currentVehicle.first?.fuelTypeTwo != FuelType.none){
                Button(action: {
                    withAnimation(.easeOut) {
                        checkmark1 = false
                        checkmark2 = true
                        addExpVM.selectedFuel = dataVM.currentVehicle.first?.fuelTypeTwo.label ?? ""
                        fuelVM.secondaryFuelType = dataVM.currentVehicle.first?.fuelTypeTwo ?? FuelType.none
                        addExpVM.fuel = fuelVM.secondarySelectedFuel
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    HStack {
                        Text(dataVM.currentVehicle.first?.fuelTypeTwo.label ?? "")
                            .font(Typography.headerM)
                            .foregroundColor(Palette.black)
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                            .opacity(checkmark2 ? 1.0 : 0.0)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
}

struct CustomCategoryPicker : View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var dataVM : DataViewModel
    @StateObject var addExpVM : AddExpenseViewModel
    @StateObject var reminderVM: AddReminderViewModel
    @ObservedObject var categoryVM : CategoryViewModel
    @Binding var selectedItem: Category
    
    var body: some View {
        List{
            ForEach(Category.allCases,id:\.self){category in
                Button(action: {
                    withAnimation{
                    if(selectedItem != category){
                        selectedItem = category
                        categoryVM.defaultCategory = category
                        addExpVM.selectedCategory = category.label
                        addExpVM.category = categoryVM.selectedCategory
                        reminderVM.selectedCategory = category.label
                        reminderVM.category = categoryVM.selectedCategory
                    }
                    }
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Text(category.label)
                            .font(Typography.headerM)
                            .foregroundColor(Palette.black)
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                            .opacity(selectedItem == category ? 1.0 : 0.0)
                    }
                })
            }
        }.listStyle(.insetGrouped)
    }
    
    
}
