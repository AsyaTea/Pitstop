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
    @ObservedObject var dataVM: DataViewModel

    @State private var showOdometerAlert = false

    @State private var reminder: Reminder = .mock()

    @State var fuelExpense: FuelExpense = .mock()
    @State var fuelCategories: [FuelType] = []

    // FIXME: Focus keyboard
    @FocusState var focusedField: FocusField?

    // To dismiss the modal
    @Environment(\.presentationMode) private var presentationMode

    @State private var currentPickerTab: AddReportTabs = .fuel

    var body: some View {
        NavigationView {
            VStack {
                // MARK: Custom TextField

                switch currentPickerTab {
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
                    HStack {
                        Spacer()
                        TextField("0.0", value: $fuelExpense.totalPrice, format: .number)
                            .keyboardType(.decimalPad)
                            .font(Typography.headerXXL)
                            .foregroundColor(Palette.black)
                            .fixedSize(horizontal: true, vertical: true)
                        Text(utilityVM.currency)
                            .font(Typography.headerXXL)
                            .foregroundColor(Palette.black)
                        Spacer()
                    }
                    .padding(.top, 15)
                }

                // MARK: Custom segmented picker

                SegmentedPicker(currentTab: $currentPickerTab, onTap: {})
                    .padding(.horizontal, 32)
                    .padding(.top, -10.0)

                // MARK: List

                switch currentPickerTab {
                case .odometer:
                    OdometerListView(addExpVM: addExpVM, utilityVM: utilityVM, focusedField: $focusedField)
                case .reminder:
                    ReminderListView(reminder: $reminder, focusedField: $focusedField)
                case .fuel:
                    FuelExpenseInputView(vehicleFuels: fuelCategories, fuelExpense: $fuelExpense)
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
                        vehicleManager.currentVehicle.odometer = fuelExpense.odometer
                        do {
                            try vehicleManager.currentVehicle.saveToModelContext(context: modelContext)
                        } catch {
                            print("error saving current vehicle odometer \(error)")
                        }
                        fuelExpense.insert(context: modelContext)
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text(String(localized: "Save"))
                        .font(Typography.headerM)
                })
                .disabled(
                    (Float(addExpVM.odometer) ?? 0.0 < dataVM.currentVehicle.first?.odometer ?? 0 || addExpVM.price.isEmpty) &&
                        (Float(addExpVM.odometerTab) ?? 0.0 < dataVM.currentVehicle.first?.odometer ?? 0 || addExpVM.odometerTab.isEmpty) &&
                        reminder.title.isEmpty && fuelExpense.totalPrice.isZero)
                .opacity(
                    (Float(addExpVM.odometer) ?? 0.0 < dataVM.currentVehicle.first?.odometer ?? 0 || addExpVM.price.isEmpty) &&
                        (Float(addExpVM.odometerTab) ?? 0.0 < dataVM.currentVehicle.first?.odometer ?? 0 || addExpVM.odometerTab.isEmpty) &&
                        reminder.title.isEmpty && fuelExpense.totalPrice.isZero ? 0.6 : 1)
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
        .onAppear {
            initializeFuelExpense()
        }
    }

    private func initializeFuelExpense() {
        let currentVehicle = vehicleManager.currentVehicle
        fuelExpense = FuelExpense(
            totalPrice: 0.0,
            quantity: 0,
            pricePerUnit: 0.0,
            odometer: currentVehicle.odometer,
            fuelType: currentVehicle.mainFuelType,
            date: Date(),
            vehicle: currentVehicle
        )

        fuelCategories.append(currentVehicle.mainFuelType)
        guard let secondaryFuelType = currentVehicle.secondaryFuelType else { return }
        fuelCategories.append(secondaryFuelType)
    }
}

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
    case odometerTab
    case reminderTab
    case fuelTab
    case odometer
    case liter
    case priceLiter
    case note
}

enum AddReportTabs: String, CaseIterable, Identifiable {
    case fuel
    case reminder
    case odometer

    var id: Self { self }
}
