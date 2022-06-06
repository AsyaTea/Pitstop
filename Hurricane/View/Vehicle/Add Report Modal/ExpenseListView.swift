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
    @StateObject var dataVM : DataViewModel
    @ObservedObject var categoryVM : CategoryViewModel
    @StateObject var fuelVM = FuelViewModel()
    @StateObject var reminderVM : AddReminderViewModel
    
    var focusedField : FocusState<FocusField?>.Binding
    
//    @State private var selectedFuel : String = ""


    @State private var checkmark1 = true
    @State private var checkmark2 = false
    
    let formatter: NumberFormatter = {
          let formatter = NumberFormatter()
          formatter.numberStyle = .decimal
          return formatter
      }()
    
    var body: some View {
        
        List{
     
            //MARK: CUSTOM CATEGORY PICKER
            HStack{
                ListCategoryComponent(title: "Category", iconName: "category", color: Palette.colorYellow)
                Spacer()
                NavigationLink(destination: CustomCategoryPicker(dataVM: dataVM, addExpVM: addExpVM, reminderVM: reminderVM, categoryVM: categoryVM, checkmark: $checkmark1)){
                Spacer()
                Text(addExpVM.selectedCategory)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.greyMiddle)
                }
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            //MARK: ODOMETER
            HStack{
                ListCategoryComponent(title: "Odometer", iconName: "odometer", color: Palette.colorBlue)
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
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            
            //MARK: FUEL TYPE
            if(addExpVM.selectedCategory == "Fuel"){
                HStack{
                    ListCategoryComponent(title: "Fuel type", iconName: "fuelType", color: Palette.colorOrange)
                    Spacer()
                    NavigationLink(destination: CustomFuelPicker(dataVM: dataVM,addExpVM: addExpVM, fuelVM: fuelVM, checkmark1: $checkmark1,checkmark2: $checkmark2)){
                        Spacer()
                        Text(addExpVM.selectedFuel)
                            .font(Typography.headerM)
                            .foregroundColor(Palette.greyMiddle)
                    }
                }.listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            }
            
            //MARK: DATE PICKER
            DatePicker(selection: $addExpVM.expenseS.date,in: ...Date(), displayedComponents: [.date]) {
                ListCategoryComponent(title: "Day", iconName: "day", color: Palette.colorGreen)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            //MARK: LITERS & PRICE/LITER
            if(addExpVM.selectedCategory == "Fuel"){
                HStack{
                    ZStack{
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundColor(addExpVM.liters == 0 ? Palette.greyLight : Palette.colorOrange)
                        Image(addExpVM.liters == 0 ? "liters" : "literColored")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    Text("Liters")
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                    Spacer()
                    TextField("0",value: $addExpVM.liters,formatter: formatter)
                        .disableAutocorrection(true)
                        .keyboardType(.decimalPad)
                        .focused(focusedField, equals: .liter)
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
                            .foregroundColor(addExpVM.pricePerLiter == 0.0 ? Palette.greyLight : Palette.colorYellow)
                        Image(addExpVM.pricePerLiter == 0.0 ?  "priceLiter" : "priceLiterColored")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    Text("Price/Liter")
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                    Spacer()
                    TextField("0",value: $addExpVM.pricePerLiter,formatter: formatter)
                        .disableAutocorrection(true)
                        .focused(focusedField, equals: .priceLiter)
                        .fixedSize(horizontal: true, vertical: true)
                        .keyboardType(.decimalPad)
                        .font(Typography.headerM)
                    
                    Text(utilityVM.currency)
                        .foregroundColor(Palette.black)
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
                TextField("Note",text: $addExpVM.note)
                    .disableAutocorrection(true)
                    .focused(focusedField, equals: .note)
                    .font(Typography.headerM)
                
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
    
    @StateObject var dataVM : DataViewModel
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
    @StateObject var dataVM : DataViewModel
    @StateObject var addExpVM : AddExpenseViewModel
    @StateObject var reminderVM: AddReminderViewModel
    @ObservedObject var categoryVM : CategoryViewModel
    @Binding var checkmark : Bool
    
    var body: some View {
        List{
            ForEach(Category.allCases,id:\.self){category in
                Button(action: {
                    checkmark.toggle()
                    categoryVM.defaultCategory = category
                    addExpVM.selectedCategory = category.label
                    addExpVM.category = categoryVM.selectedCategory
                    reminderVM.selectedCategory = category.label
                    reminderVM.category = categoryVM.selectedCategory
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Text(category.label)
                            .font(Typography.headerM)
                            .foregroundColor(Palette.black)
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                            .opacity(checkmark ? 1.0 : 0.0)
                    }
                })
            }
        }.listStyle(.insetGrouped)
    }
    
    
}
