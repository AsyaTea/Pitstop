//
//  OdometerListView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import SwiftUI

// Deprecated: - OdometerListView
// The abiltiy to update the odometer at any point in time interferes with the logic of the statistics
// and could lead to potential errors. The odometer should be updated only when adding a new fuel entry.
struct OdometerListView: View {
    @StateObject var addExpVM: AddExpenseViewModel
    @ObservedObject var utilityVM: UtilityViewModel
    var focusedField: FocusState<FocusField?>.Binding

    var body: some View {
        CustomList {
            // MARK: DATE

            CategoryInputView(
                categoryInfo: .init(title: "Day", icon: .day, color: Palette.colorGreen),
                type: .date(value: $addExpVM.date)
            )

            // MARK: NOTE

            HStack {
                ZStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundColor(addExpVM.note.isEmpty ? Palette.greyLight : Palette.colorViolet)
                    Image(addExpVM.note.isEmpty ? .note : .noteColored)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                TextField(String(localized: "Note"), text: $addExpVM.note)
                    .disableAutocorrection(true)
                    .focused(focusedField, equals: .note)
                    .font(Typography.headerM)
            }
        }
        .padding(.top, -10)
        .onAppear {
            /// Setting the keyboard focus on the price when opening the modal
            if addExpVM.odometer.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { /// Anything over 0.5 delay seems to work
                    focusedField.wrappedValue = .odometerTab
                }
            }
        }
    }
}
