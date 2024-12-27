//
//  AddReportView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct AddReportView: View {
    @Environment(\.modelContext) private var modelContext

    @ObservedObject var utilityVM: UtilityViewModel
    @StateObject var addExpVM: AddExpenseViewModel = .init()
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var dataVM: DataViewModel

    @State private var showDate = false

    @State var reminder: Reminder = .mock()

    // Custom picker tabs
    @State private var pickerTabs = [String(localized: "Expense"), String(localized: "Odometer"), String(localized: "Reminder")]

    // Matching geometry namespace
    @Namespace var animation

    // Focus keyboard
    @FocusState var focusedField: FocusField?

    // To dismiss the modal
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                // MARK: Custom TextField

                if addExpVM.currentPickerTab == String(localized: "Expense") {
                    TextFieldComponent(submitField: $addExpVM.price, placeholder: "0",
                                       attribute: utilityVM.currency, keyboardType: .decimalPad,
                                       focusedField: $focusedField, defaultFocus: .priceTab)
                        .padding(.top, 15)
                } else if addExpVM.currentPickerTab == String(localized: "Odometer") {
                    TextFieldComponent(submitField: $addExpVM.odometerTab,
                                       placeholder: String(Int(dataVM.currentVehicle.first?.odometer ?? 0)),
                                       attribute: utilityVM.unit,
                                       keyboardType: .numberPad,
                                       focusedField: $focusedField,
                                       defaultFocus: .odometerTab)
                        .padding(.top, 15)
                } else {
                    TextFieldComponent(
                        submitField: $reminder.title,
                        placeholder: "-",
                        attribute: "ㅤ",
                        keyboardType: .default,
                        focusedField: $focusedField,
                        defaultFocus: .reminderTab
                    )
                    .padding(.top, 15)
                }

                // MARK: Custom segmented picker

                CustomSegmentedPicker()
                    .padding(.horizontal, 32)
                    .padding(.top, -10.0)

                // MARK: List

                if addExpVM.currentPickerTab == String(localized: "Expense") {
                    ExpenseListView(addExpVM: addExpVM, utilityVM: utilityVM,
                                    dataVM: dataVM, categoryVM: categoryVM,
                                    focusedField: $focusedField)
                } else if addExpVM.currentPickerTab == String(localized: "Odometer") {
                    OdometerListView(addExpVM: addExpVM, utilityVM: utilityVM, focusedField: $focusedField)
                } else {
                    ReminderListView(reminder: $reminder, focusedField: $focusedField)
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
                    if addExpVM.currentPickerTab == String(localized: "Expense") {
                        addExpVM.createExpense()
                        dataVM.addExpense(expense: addExpVM.expenseS)
                        dataVM.addNewExpensePriceToTotal(expense: addExpVM.expenseS)
                        categoryVM.retrieveAndUpdate(vehicleID: dataVM.currentVehicle.first!.vehicleID)
                    } else if addExpVM.currentPickerTab == String(localized: "Odometer") {
                        addExpVM.category = 7 // other
                        addExpVM.createExpense()
                        dataVM.addExpense(expense: addExpVM.expenseS)
                        dataVM.addNewExpensePriceToTotal(expense: addExpVM.expenseS)
                        categoryVM.retrieveAndUpdate(vehicleID: dataVM.currentVehicle.first!.vehicleID)
                    } else {
                        NotificationManager.shared.requestAuthNotifications()
                        do {
                            try reminder.saveToModelContext(context: modelContext)
                        } catch {
                            // TODO: Implement error handling
                            print("error \(error)")
                        }
                        NotificationManager.shared.createNotification(for: reminder)
                    }
                    presentationMode.wrappedValue.dismiss()

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
        }
    }

    @ViewBuilder
    func CustomSegmentedPicker() -> some View {
        HStack(spacing: 10) {
            ForEach(pickerTabs, id: \.self) { tab in
                Text(tab)
                    .fixedSize()
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .font(Typography.headerS)
                    .foregroundColor(Palette.black)
                    .background {
                        if addExpVM.currentPickerTab == tab {
                            Capsule()
                                .fill(Palette.greyLight)
                                .matchedGeometryEffect(id: "pickerTab", in: animation)
                        }
                    }
                    .containerShape(Capsule())
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            addExpVM.currentPickerTab = tab
                            let haptic = UIImpactFeedbackGenerator(style: .soft)
                            haptic.impactOccurred()
                        }
                        addExpVM.resetTabFields(tab: addExpVM.currentPickerTab)
                    }
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
