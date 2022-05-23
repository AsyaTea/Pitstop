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
    
    var focusedField : FocusState<FocusField?>.Binding
    
    @StateObject var fuelVM = FuelViewModel()
    @State private var selectedItem : String = ""
    @State private var checkmark1 = true
    @State private var checkmark2 = false
    
    let formatter: NumberFormatter = {
          let formatter = NumberFormatter()
          formatter.numberStyle = .decimal
          return formatter
      }()
    
    
    
    var body: some View {
        
        List{
            //MARK: CATEGORY PICKER
            Picker(selection: $addExpVM.selectedCategory, content: {
                ForEach(addExpVM.categoryTypes, id: \.self) {
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
                TextField("100", value: $addExpVM.odometer,formatter: NumberFormatter())
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
                    NavigationLink(destination: CustomFuelPicker(selectedItem: $selectedItem, dataVM: dataVM,addExpVM: addExpVM, fuelVM: fuelVM, checkmark1: $checkmark1,checkmark2: $checkmark2)){
                        Spacer()
                        Text(selectedItem)
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
            fuelVM.defaultFuelType = dataVM.currentVehicle.first?.fuelTypeOne ?? FuelType.none
            addExpVM.expenseS.fuelType = fuelVM.defaultSelectedFuel
            
            
            if(selectedItem == ""){
            selectedItem = dataVM.currentVehicle.first?.fuelTypeOne.label ?? ""
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
    
    @Binding var selectedItem : String
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
                    selectedItem = dataVM.currentVehicle.first?.fuelTypeOne.label ?? ""
                    fuelVM.defaultFuelType = dataVM.currentVehicle.first?.fuelTypeOne ?? FuelType.none
                    addExpVM.expenseS.fuelType = fuelVM.defaultSelectedFuel
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
                        selectedItem = dataVM.currentVehicle.first?.fuelTypeTwo.label ?? ""
                        fuelVM.secondaryFuelType = dataVM.currentVehicle.first?.fuelTypeTwo ?? FuelType.none
                        addExpVM.expenseS.fuelType = fuelVM.secondarySelectedFuel
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
