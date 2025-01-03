//
//  ExpenseListView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import SwiftUI

// DEPRECATED: - ExpenseListView
// Since it was not working most of the time. I prefer to focus only on fuel for now
struct ExpenseListView: View {
    @StateObject var addExpVM: AddExpenseViewModel
    @ObservedObject var utilityVM: UtilityViewModel
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var categoryVM: CategoryViewModel

    var focusedField: FocusState<FocusField?>.Binding

    @State var selectedItem: Category = .fuel
    @State private var checkmark1 = true
    @State private var checkmark2 = false

    var body: some View {
        CustomList {
            // MARK: CUSTOM CATEGORY PICKER

            HStack {
                CategoryRow(input: .init(
                    title: String(localized: "Category"),
                    icon: .category,
                    color: Palette.colorYellow
                )
                )
                Spacer()
                NavigationLink(
                    destination: CustomCategoryPicker(
                        addExpVM: addExpVM,
                        categoryVM: categoryVM,
                        selectedItem: $selectedItem
                    )
                ) {
                    HStack {
                        Spacer()
                        Text(addExpVM.selectedCategory)
                            .fixedSize()
                            .font(Typography.headerM)
                            .foregroundColor(Palette.greyMiddle)
                    }
                }
            }

            // MARK: ODOMETER

            HStack {
                CategoryRow(input: .init(
                    title: String(localized: "Odometer"),
                    icon: .odometer,
                    color: Palette.colorBlue
                )
                )
                Spacer()
                TextField(String(Int(dataVM.currentVehicle.first?.odometer ?? 0)), text: $addExpVM.odometer)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .focused(focusedField, equals: .odometer)
                    .keyboardType(.decimalPad)
                    .fixedSize(horizontal: true, vertical: true)
                Text(utilityVM.unit)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField.wrappedValue = .odometer
            }

            // MARK: DATE PICKER

            DatePicker(selection: $addExpVM.expenseS.date, in: ...Date(), displayedComponents: [.date]) {
                CategoryRow(input: .init(title: String(localized: "Day"), icon: .day, color: Palette.colorGreen))
            }

            // MARK: NOTE

            HStack {
                ZStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundColor(addExpVM.note.isEmpty ? Palette.greyLight : Palette.colorViolet)
                    Image(addExpVM.note.isEmpty ? "Note" : "noteColored")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                TextField(String(localized: "Note"), text: $addExpVM.note)
                    .disableAutocorrection(true)
                    .focused(focusedField, equals: .note)
                    .font(Typography.headerM)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField.wrappedValue = .note
            }
        }
        .padding(.top, -5)
    }
}

// struct ExpenseListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpenseListView()
//    }
// }

// TODO: Remove when no longer used
struct CustomCategoryPicker: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var addExpVM: AddExpenseViewModel
    @ObservedObject var categoryVM: CategoryViewModel
    @Binding var selectedItem: Category

    var body: some View {
        List {
            ForEach(Category.allCases, id: \.self) { category in
                Button(action: {
                    withAnimation {
                        if selectedItem != category {
                            selectedItem = category
                            categoryVM.defaultCategory = category
                            addExpVM.selectedCategory = category.label
                            addExpVM.category = categoryVM.selectedCategory
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Text(category.label)
                            .font(Typography.headerM)
                            .foregroundColor(Palette.black)
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                            .opacity(selectedItem == category ? 1.0 : 0.0)
                    }
                })
            }
        }
        .listStyle(.insetGrouped)
    }
}
