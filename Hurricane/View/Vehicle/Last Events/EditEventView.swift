//
//  EditEventView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 31/05/22.
//

import SwiftUI

struct EditEventView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var utilityVM : UtilityViewModel
    @StateObject var dataVM : DataViewModel
    var category : Category
    @State var showingAlert = false
    
    var body: some View {
        NavigationView{
            VStack{
                if(category == .fuel){
                FuelEventListFields(utilityVM: utilityVM, category: category)
                }
                else{
                EventListFields(utilityVM: utilityVM, category: category)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                            .font(Typography.headerM)
                    })
                    .accentColor(Palette.greyHard),
                trailing:
                    Button(action: {
                        do {
                            try dataVM.updateExpense(utilityVM.expenseToEdit)
                        }
                        catch{
                            print(error)
                        }
                        dataVM.getTotalExpense(expenses: dataVM.expenseList)
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                            .font(Typography.headerM)
                    })
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(category.label)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
            .overlay(
                VStack{
                    Spacer(minLength: UIScreen.main.bounds.size.height * 0.78)
                    Button(action: {
                        showingAlert.toggle()
                    }, label: {
                        DeleteButton()
                    })
                    Spacer()
                }
            )
            .alert(isPresented:$showingAlert) {
                    Alert(
                        title: Text("Are you sure you want to delete this?"),
                        message: Text("There is no undo"),
                        primaryButton: .destructive(Text("Delete")) {
                            dataVM.deleteExpenseState(expenseS: utilityVM.expenseToEdit)
                            dataVM.getExpensesCoreData(filter: nil, storage: { storage in
                                dataVM.expenseList = storage
                                dataVM.expenseFilteredList = storage
                            })
                            //SE METTO STA ROBA CRASHA, TO FIX PROSSIMAMENTE
//                            dataVM.getTotalExpense(expenses: dataVM.expenseList)
//                            dataVM.getMonths(expenses: dataVM.expenseList)
                            self.presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
        }
    }
}


struct DeleteButton : View {
    var body: some View {
        ZStack{
            Capsule(style: .continuous)
                .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055, alignment: .center)
                .foregroundColor(Palette.black)
            HStack{
                Spacer()
                Image("deleteIcon")
                    .resizable()
                    .foregroundColor(Palette.white)
                    .frame(width: 14, height: 14)
                Text("Delete report")
                    .foregroundColor(Palette.white)
                    .font(Typography.ControlS)
                Spacer()
            }
        }
    }
}

struct FuelEventListFields: View {
    
    @StateObject var utilityVM : UtilityViewModel
    var category : Category
    
    var body: some View {
        List{
            
            //MARK: CATEGORY FUEL
            HStack{
                ListCategoryComponent(title: "Amount", iconName: "other", color: Palette.colorViolet)
                Spacer()
                TextField("100", value: $utilityVM.expenseToEdit.price,formatter: NumberFormatter())
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .keyboardType(.decimalPad)
                    .fixedSize(horizontal: true, vertical: true)
                   
                Text(utilityVM.currency)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
//            HStack{
//                ListCategoryComponent(title: "Category", iconName: "category", color: Palette.colorYellow)
//                Spacer()
//                Text(category.label)
//                    .font(Typography.headerM)
//                    .foregroundColor(Palette.black)
//            }
//            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            
            //MARK: DATE
            DatePicker(selection: $utilityVM.expenseToEdit.date, displayedComponents: [.date]) {
                ListCategoryComponent(title: "Day", iconName: "day", color: Palette.colorGreen)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            //MARK: ODOMETER
            HStack{
                ListCategoryComponent(title: "Odometer", iconName: "odometer", color: Palette.colorBlue)
                Spacer()
                TextField("100", value: $utilityVM.expenseToEdit.odometer,formatter: NumberFormatter())
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .keyboardType(.numberPad)
                    .fixedSize(horizontal: true, vertical: true)
                Text(utilityVM.unit)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            //MARK: FUEL TYPE
            HStack{
                ListCategoryComponent(title: "Fuel type", iconName: "fuelType", color: Palette.colorOrange)
                Spacer()
                Text((FuelType.init(rawValue: Int(utilityVM.expenseToEdit.fuelType ?? 0)) ?? .none).label)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            HStack{
                ListCategoryComponent(
                    title: "Price/Liter",
                    iconName: utilityVM.expenseToEdit.priceLiter == 0 ? "priceLiter" : "priceLiterColored",
                    color:utilityVM.expenseToEdit.liters == 0 ? Palette.greyLight : Palette.colorYellow)
                Spacer()
                TextField("0", value: $utilityVM.expenseToEdit.priceLiter,formatter: NumberFormatter())
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .keyboardType(.decimalPad)
                    .fixedSize(horizontal: true, vertical: true)
                
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            HStack{
                ListCategoryComponent(
                    title: "Liters",
                    iconName: utilityVM.expenseToEdit.liters == 0 ? "liters" : "literColored",
                    color: utilityVM.expenseToEdit.liters == 0 ? Palette.greyLight : Palette.colorOrange)
                Spacer()
                TextField("0", value: $utilityVM.expenseToEdit.liters,formatter: NumberFormatter())
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .keyboardType(.decimalPad)
                    .fixedSize(horizontal: true, vertical: true)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            HStack{
                ListCategoryComponent(
                    title: "Note",
                    iconName: utilityVM.expenseToEdit.note.isEmpty ? "note" : "noteColored",
                    color: utilityVM.expenseToEdit.note.isEmpty ? Palette.greyLight : Palette.colorViolet)
                Spacer()
                TextField("Note", text: $utilityVM.expenseToEdit.note)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .fixedSize(horizontal: true, vertical: true)
    //                    .focused(focusedField, equals: .odometer)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
        }
    }
}

struct EventListFields: View {
    
    @StateObject var utilityVM : UtilityViewModel
    var category : Category
    
    var body: some View {
        List{
            
            HStack{
                ListCategoryComponent(title: "Amount", iconName: "other", color: Palette.colorViolet)
                Spacer()
                TextField("100", value: $utilityVM.expenseToEdit.price,formatter: NumberFormatter())
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .keyboardType(.decimalPad)
                    .fixedSize(horizontal: true, vertical: true)
                   
                Text(utilityVM.currency)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
//            HStack{
//                ListCategoryComponent(title: "Category", iconName: "category", color: Palette.colorYellow)
//                Spacer()
//                Text(category.label)
//                    .font(Typography.headerM)
//                    .foregroundColor(Palette.black)
//            }
//            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            
            //MARK: DATE
            DatePicker(selection: $utilityVM.expenseToEdit.date, displayedComponents: [.date]) {
                ListCategoryComponent(title: "Day", iconName: "day", color: Palette.colorGreen)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            //MARK: ODOMETER
            HStack{
                ListCategoryComponent(title: "Odometer", iconName: "odometer", color: Palette.colorBlue)
                Spacer()
                TextField("100", value: $utilityVM.expenseToEdit.odometer,formatter: NumberFormatter())
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .keyboardType(.numberPad)
                    .fixedSize(horizontal: true, vertical: true)
                Text(utilityVM.unit)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            HStack{
                ListCategoryComponent(
                    title: "Note",
                    iconName: utilityVM.expenseToEdit.note.isEmpty ? "note" : "noteColored",
                    color: utilityVM.expenseToEdit.note.isEmpty ? Palette.greyLight : Palette.colorViolet)
                Spacer()
                TextField("Note", text: $utilityVM.expenseToEdit.note)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .fixedSize(horizontal: true, vertical: true)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
        }
    }
}

//struct EditEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditEventView()
//    }
//}
