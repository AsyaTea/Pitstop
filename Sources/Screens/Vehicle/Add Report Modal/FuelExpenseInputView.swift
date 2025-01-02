//
//  FuelExpenseInputView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 02/01/25.
//

import SwiftUI

struct FuelExpenseInputView: View {
    var body: some View {
        CustomList {
            CategoryInputView(type: .field(value: .constant("ciao"), unit: "L"))
        }
    }
}

struct CategoryInputView: View {
    let type: InputType

    var body: some View {
        HStack {
            switch type {
            case let .field(value, unit):
                CategoryRow(title: "Odometer", icon: .odometer, color: Palette.colorBlue)
                Spacer()
                TextField("value", text: value)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .keyboardType(.decimalPad)
                    .fixedSize(horizontal: true, vertical: true)
                Text(unit)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            case let .date(value):
                DatePicker(selection: value, in: ...Date(), displayedComponents: [.date]) {
                    CategoryRow(title: String(localized: "Day"), icon: .day, color: Palette.colorGreen)
                }
            }
        }
    }

    enum InputType {
        case field(value: Binding<String>, unit: String)
        case date(value: Binding<Date>)
    }
}
