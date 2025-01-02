//
//  AddReportView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct AddReportView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var vehicleManager: VehicleManager
    
    @ObservedObject var utilityVM: UtilityViewModel
    @StateObject var addExpVM: AddExpenseViewModel = .init()
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var dataVM: DataViewModel
    
    @State private var showDate = false
    @State private var showOdometerAlert = false
    
    @State var reminder: Reminder = .mock()
    
    // Focus keyboard
    @FocusState var focusedField: FocusField?
    
    // To dismiss the modal
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var currentPickerTab: AddReportTabs = .expense
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: Custom TextField
                
                switch currentPickerTab {
                case .expense:
                    TextFieldComponent(
                        submitField: $addExpVM.price,
                        placeholder: "0",
                        attribute: utilityVM.currency,
                        keyboardType: .decimalPad,
                        focusedField: $focusedField,
                        defaultFocus: .priceTab
                    )
                    .padding(.top, 15)
                case .odometer:
                    TextFieldComponent(
                        submitField: $addExpVM.odometerTab,
                        placeholder: String(Int(dataVM.currentVehicle.first?.odometer ?? 0)),
                        attribute: utilityVM.unit,
                        keyboardType: .numberPad,
                        focusedField: $focusedField,
                        defaultFocus: .odometerTab
                    )
                    .padding(.top, 15)
                case .reminder:
                    TextFieldComponent(
                        submitField: $reminder.title,
                        placeholder: "-",
                        attribute: "ㅤ",
                        keyboardType: .default,
                        focusedField: $focusedField,
                        defaultFocus: .reminderTab
                    )
                    .padding(.top, 15)
                case .fuel:
                    Text("Work in progress")
                }
                
                // MARK: Custom segmented picker
                
                SegmentedPicker(currentTab: $currentPickerTab, onTap: {})
                    .padding(.horizontal, 32)
                    .padding(.top, -10.0)
                
                // MARK: List
                
                switch currentPickerTab {
                case .expense:
                    ExpenseListView(
                        addExpVM: addExpVM,
                        utilityVM: utilityVM,
                        dataVM: dataVM,
                        categoryVM: categoryVM,
                        focusedField: $focusedField
                    )
                case .odometer:
                    OdometerListView(addExpVM: addExpVM, utilityVM: utilityVM, focusedField: $focusedField)
                case .reminder:
                    ReminderListView(reminder: $reminder, focusedField: $focusedField)
                case .fuel:
                    Text("Work in progress")
                }
            }
            .background(Palette.greyBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                            .font(Typography.headerM)
                    })
                    .accentColor(Palette.greyHard),
                trailing:
                    Button(action: {
                        switch currentPickerTab {
                        case .expense:
                            addExpVM.createExpense()
                            dataVM.addExpense(expense: addExpVM.expenseS)
                            dataVM.addNewExpensePriceToTotal(expense: addExpVM.expenseS)
                            categoryVM.retrieveAndUpdate(vehicleID: dataVM.currentVehicle.first!.vehicleID)
                            presentationMode.wrappedValue.dismiss()
                        case .odometer:
                            guard let odometerValue = Float(addExpVM.odometerTab) else { return }
                            if odometerValue < vehicleManager.currentVehicle.odometer {
                                showOdometerAlert.toggle()
                            } else {
                                vehicleManager.currentVehicle.odometer = odometerValue
                                presentationMode.wrappedValue.dismiss()
                            }
                        case .reminder:
                            NotificationManager.shared.requestAuthNotifications()
                            do {
                                try reminder.saveToModelContext(context: modelContext)
                            } catch {
                                // TODO: Implement error handling
                                print("error \(error)")
                            }
                            NotificationManager.shared.createNotification(for: reminder)
                            presentationMode.wrappedValue.dismiss()
                        case .fuel:
                            break
                        }
                    }, label: {
                        Text(String(localized: "Save"))
                            .font(Typography.headerM)
                    })
                    .disabled(
                        (Float(addExpVM.odometer) ?? 0.0 < dataVM.currentVehicle.first?.odometer ?? 0 || addExpVM.price.isEmpty) &&
                        (Float(addExpVM.odometerTab) ?? 0.0 < dataVM.currentVehicle.first?.odometer ?? 0 || addExpVM.odometerTab.isEmpty) &&
                        reminder.title.isEmpty)
                    .opacity(
                        (Float(addExpVM.odometer) ?? 0.0 < dataVM.currentVehicle.first?.odometer ?? 0 || addExpVM.price.isEmpty) &&
                        (Float(addExpVM.odometerTab) ?? 0.0 < dataVM.currentVehicle.first?.odometer ?? 0 || addExpVM.odometerTab.isEmpty) &&
                        reminder.title.isEmpty ? 0.6 : 1)
            )
            .onAppear {
                addExpVM.odometer = String(Int(dataVM.currentVehicle.first?.odometer ?? 0))
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
                ToolbarItem(placement: .principal) {
                    Text(String(localized: "New report"))
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
            .alert(isPresented: $showOdometerAlert) {
                Alert(
                    title: Text("Attention"),
                    message: Text("Can't set lower odometer value than current value")
                )
            }
        }
    }
}

// struct AddReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddReportView()
//    }
// }

struct TextFieldComponent: View {
    @Binding var submitField: String
    var placeholder: String
    var attribute: String
    var keyboardType: UIKeyboardType

    var focusedField: FocusState<FocusField?>.Binding
    var defaultFocus: FocusField

    var body: some View {
        HStack {
            Spacer()
            TextField(placeholder, text: $submitField)
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
    case odometer
    case liter
    case priceLiter
    case note
}

enum AddReportTabs: String, CaseIterable, Identifiable {
    case fuel
    case expense
    case reminder
    case odometer

    var id: Self { self }
}
