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
