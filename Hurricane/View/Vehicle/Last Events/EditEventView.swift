//
//  EditEventView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 31/05/22.
//

import SwiftUI

struct EditEventView: View {
    @Environment(\.presentationMode) private var presentationMode

    @StateObject var utilityVM: UtilityViewModel
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var categoryVM: CategoryViewModel
    var category: Category
    @State var showingAlert = false

    var body: some View {
        NavigationView {
            VStack {
                if category == .fuel {
                    FuelEventListFields(utilityVM: utilityVM, dataVM: dataVM, category: category)
                } else {
                    EventListFields(utilityVM: utilityVM, dataVM: dataVM, category: category)
                }
            }
            .background(Palette.greyBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(category.label)
            .navigationBarItems(
                leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Image("arrowLeft")

                        Text("Back")
                            .font(Typography.headerM)
                    }
                })
                .accentColor(Palette.greyHard),
                trailing:
                Button(action: {
                    do {
                        try dataVM.updateExpense(utilityVM.expenseToEdit)
                    } catch {
                        print(error)
                    }
                    dataVM.getTotalExpense(expenses: dataVM.expenseList)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                        .font(Typography.headerM)
                })
//                    .disabled((Float(utilityVM.expenseToEdit.odometer) <= dataVM.currentVehicle.first?.odometer ?? 0 ))
//                    .opacity((Float(utilityVM.expenseToEdit.odometer) <= dataVM.currentVehicle.first?.odometer ?? 0 ) ? 0.6 : 1)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(category.label)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
            .overlay(
                VStack {
                    Spacer(minLength: UIScreen.main.bounds.size.height * 0.78)
                    Button(action: {
                        showingAlert.toggle()
                    }, label: {
                        DeleteButton(title: "Delete report")
                    })
                    Spacer()
                }
            )
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text(String(localized: "Are you sure you want to delete this report?")),
                    message: Text(String(localized: "This action cannot be undone")),
                    primaryButton: .destructive(Text(String(localized: "Delete"))) {
                        dataVM.deleteExpense(expenseS: utilityVM.expenseToEdit)
                        dataVM.getExpensesCoreData(filter: nil, storage: { storage in
                            dataVM.expenseList = storage
                            dataVM.expenseFilteredList = storage
                            categoryVM.retrieveAndUpdate(vehicleID: dataVM.currentVehicle.first!.vehicleID)
                        })

                        // SE METTO STA ROBA CRASHA, TO FIX PROSSIMAMENTE
                        //                            dataVM.getTotalExpense(expenses: dataVM.expenseList)
                        //                            dataVM.getMonths(expenses: dataVM.expenseList)
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct DeleteButton: View {
    var title: LocalizedStringKey

    var body: some View {
        ZStack {
            Capsule(style: .continuous)
                .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055, alignment: .center)
                .foregroundColor(Palette.black)
            HStack {
                Spacer()
                Image("deleteIcon")
                    .resizable()
                    .foregroundColor(Palette.white)
                    .frame(width: 14, height: 14)
                Text(title)
                    .foregroundColor(Palette.white)
                    .font(Typography.ControlS)
                Spacer()
            }
        }
    }
}

struct FuelEventListFields: View {
    @StateObject var utilityVM: UtilityViewModel
    @ObservedObject var dataVM: DataViewModel
    var category: Category
    @FocusState var focusedField: FocusField?

    var body: some View {
        CustomList {
            // MARK: AMOUNT

            HStack {
                CategoryRow(title: String(localized: "Cost"), iconName: "other", color: Palette.colorViolet)
                Spacer()
                TextField("100", value: $utilityVM.expenseToEdit.price, formatter: NumberFormatter())
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .keyboardType(.decimalPad)
                    .fixedSize(horizontal: true, vertical: true)
                    .focused($focusedField, equals: .priceTab)

                Text(utilityVM.currency)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = .priceTab
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: DATE

            DatePicker(selection: $utilityVM.expenseToEdit.date, displayedComponents: [.date]) {
                CategoryRow(title: String(localized: "Day"), iconName: "day", color: Palette.colorGreen)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: ODOMETER

            HStack {
                CategoryRow(title: String(localized: "Odometer"), iconName: "odometer", color: Palette.colorBlue)
                Spacer()
                TextField(String(Int(dataVM.currentVehicle.first?.odometer ?? 0)), value: $utilityVM.expenseToEdit.odometer, formatter: NumberFormatter())
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .keyboardType(.numberPad)
                    .fixedSize(horizontal: true, vertical: true)
                    .focused($focusedField, equals: .odometer)
                Text(utilityVM.unit)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = .odometer
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: FUEL TYPE

            HStack {
                CategoryRow(title: String(localized: "Fuel type"), iconName: "fuelType", color: Palette.colorOrange)
                Spacer()
                Text((FuelType(rawValue: Int(utilityVM.expenseToEdit.fuelType ?? 0)) ?? .none).label)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: PRICE LITER

            HStack {
                CategoryRow(
                    title: String(localized: "Price/Liter"),
                    iconName: utilityVM.expenseToEdit.priceLiter == 0 ? "priceLiter" : "priceLiterColored",
                    color: utilityVM.expenseToEdit.priceLiter == 0 ? Palette.greyLight : Palette.colorYellow
                )
                Spacer()
                TextField("0", value: $utilityVM.expenseToEdit.priceLiter, formatter: NumberFormatter())
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .keyboardType(.decimalPad)
                    .fixedSize(horizontal: true, vertical: true)
                    .focused($focusedField, equals: .priceLiter)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = .priceLiter
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: LITER

            HStack {
                CategoryRow(
                    title: String(localized: "Liters"),
                    iconName: utilityVM.expenseToEdit.liters == 0 ? "liters" : "literColored",
                    color: utilityVM.expenseToEdit.liters == 0 ? Palette.greyLight : Palette.colorOrange
                )
                Spacer()
                TextField("0", value: $utilityVM.expenseToEdit.liters, formatter: NumberFormatter())
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .keyboardType(.decimalPad)
                    .fixedSize(horizontal: true, vertical: true)
                    .focused($focusedField, equals: .liter)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = .liter
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            HStack {
                CategoryRow(
                    title: String(localized: "Note"), iconName: utilityVM.expenseToEdit.note.isEmpty ? "note" : "noteColored",
                    color: utilityVM.expenseToEdit.note.isEmpty ? Palette.greyLight : Palette.colorViolet
                )
                Spacer()
                TextField(String(localized: "Note"), text: $utilityVM.expenseToEdit.note)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .fixedSize(horizontal: true, vertical: true)
                    .focused($focusedField, equals: .note)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = .note
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        }
        .toolbar {
            /// Keyboard focus
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Button(action: {
                        focusedField = nil
                    }, label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .resizable()
                            .foregroundColor(Palette.black)
                    })
                }
            }
        }
    }
}

struct EventListFields: View {
    @StateObject var utilityVM: UtilityViewModel
    @ObservedObject var dataVM: DataViewModel
    var category: Category
    @FocusState var focusedField: FocusField?

    var body: some View {
        CustomList {
            HStack {
                CategoryRow(title: String(localized: "Cost"), iconName: "other", color: Palette.colorViolet)
                Spacer()
                TextField("100", value: $utilityVM.expenseToEdit.price, formatter: NumberFormatter())
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .priceTab)
                    .fixedSize(horizontal: true, vertical: true)

                Text(utilityVM.currency)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = .priceTab
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: DATE

            DatePicker(selection: $utilityVM.expenseToEdit.date, displayedComponents: [.date]) {
                CategoryRow(title: String(localized: "Day"), iconName: "day", color: Palette.colorGreen)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: ODOMETER

            HStack {
                CategoryRow(title: String(localized: "Odometer"), iconName: "odometer", color: Palette.colorBlue)
                Spacer()
                TextField(String(Int(dataVM.currentVehicle.first?.odometer ?? 0)), value: $utilityVM.expenseToEdit.odometer, formatter: NumberFormatter())
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .odometer)
                    .fixedSize(horizontal: true, vertical: true)
                Text(utilityVM.unit)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = .odometer
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            HStack {
                CategoryRow(
                    title: String(localized: "Note"), iconName: utilityVM.expenseToEdit.note.isEmpty ? "note" : "noteColored",
                    color: utilityVM.expenseToEdit.note.isEmpty ? Palette.greyLight : Palette.colorViolet
                )
                Spacer()
                TextField(String(localized: "Note"), text: $utilityVM.expenseToEdit.note)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .fixedSize(horizontal: true, vertical: true)
                    .focused($focusedField, equals: .note)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = .note
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        }
        .toolbar {
            /// Keyboard focus
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Button(action: {
                        focusedField = nil
                    }, label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .resizable()
                            .foregroundColor(Palette.black)
                    })
                }
            }
        }
    }
}

// struct EditEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditEventView()
//    }
// }
