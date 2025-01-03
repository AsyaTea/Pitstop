//
//  FuelExpenseInputView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 02/01/25.
//

import SwiftData
import SwiftUI

struct FuelExpenseInputView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var odometer: Float = 0.0
    @State private var date = Date()
    @State private var quantity: Float = 0.0
    @State private var pricePerUnit: Float = 0.0
    @State private var selectedFuel: FuelType

    private var vehicleFuels: [FuelType] = []

    init(vehicleManager: VehicleManager) {
        _odometer = State(initialValue: vehicleManager.currentVehicle.odometer)
        _selectedFuel = State(initialValue: vehicleManager.currentVehicle.mainFuelType)
        vehicleFuels.append(vehicleManager.currentVehicle.mainFuelType)
        guard let secondaryFuelType = vehicleManager.currentVehicle.secondaryFuelType else { return }
        vehicleFuels.append(secondaryFuelType)
    }

    var body: some View {
        CustomList {
            CategoryInputView(
                categoryInfo: .init(
                    title: "Odometer",
                    icon: .odometer,
                    color: Palette.colorBlue
                ),
                type: .field(
                    value: $odometer,
                    unit: "km",
                    placeholder: "0",
                    keyboardType: .numberPad
                )
            )
            NavigationLink(
                destination: CategoryPicker(
                    selectedCategory: $selectedFuel,
                    categories: vehicleFuels
                )
            ) {
                HStack {
                    CategoryRow(input: .init(title: "Fuel type", icon: .fuelType, color: Palette.colorOrange))
                    Spacer()
                    Text(selectedFuel.rawValue)
                        .fixedSize()
                        .font(Typography.headerM)
                        .foregroundColor(Palette.greyMiddle)
                }
            }
            CategoryInputView(
                categoryInfo: .init(
                    title: "Day",
                    icon: .day,
                    color: Palette.colorGreen
                ),
                type: .date(value: $date)
            )
            CategoryInputView(
                categoryInfo: .init(
                    title: "Liters",
                    icon: quantity.isZero ? .liters : .literColored,
                    color: quantity.isZero ? Palette.greyLight : Palette.colorOrange
                ),
                type: .field(
                    value: $quantity,
                    unit: "L",
                    placeholder: "0",
                    keyboardType: .decimalPad
                )
            )
            CategoryInputView(
                categoryInfo: .init(
                    title: "Price/Liter",
                    icon: pricePerUnit.isZero ? .priceLiter : .priceLiterColored,
                    color: pricePerUnit.isZero ? Palette.greyLight : Palette.colorOrange
                ),
                type: .field(
                    value: $pricePerUnit,
                    unit: "€",
                    placeholder: "0",
                    keyboardType: .decimalPad
                )
            )
        }
    }
}

struct CategoryInputView: View {
    let categoryInfo: CategoryRow.Input
    let type: InputType

    var body: some View {
        HStack {
            switch type {
            case let .field(value, unit, placeholder, keyboardType):
                CategoryRow(input: categoryInfo)
                Spacer()
                TextField(placeholder, value: value, format: .number)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .keyboardType(keyboardType)
                    .fixedSize(horizontal: true, vertical: true)
                Text(unit)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            case let .date(value):
                DatePicker(selection: value, in: ...Date(), displayedComponents: [.date]) {
                    CategoryRow(input: categoryInfo)
                }
            }
        }
    }

    enum InputType {
        case field(value: Binding<Float>, unit: String, placeholder: String, keyboardType: UIKeyboardType)
        case date(value: Binding<Date>)
    }
}
