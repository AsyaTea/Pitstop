//
//  ReminderListView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import SwiftData
import SwiftUI

struct ReminderListView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var reminderVM: AddReminderViewModel

    @State private var selectedType: Reminder2.Typology = .date
    @State private var reminder: Reminder2 = .mock()

    var focusedField: FocusState<FocusField?>.Binding

    var body: some View {
        CustomList {
            // MARK: CATEGORY

            HStack {
                CategoryRow(
                    title: String(localized: "Category"),
                    icon: .category,
                    color: Palette.colorYellow
                )
                Spacer()
                NavigationLink(
                    destination: CustomCategoryPicker2(selectedCategory: $reminder.category)
                ) {
                    HStack {
                        Spacer()
                        Text(reminder.category.rawValue)
                            .fixedSize()
                            .font(Typography.headerM)
                            .foregroundColor(Palette.greyMiddle)
                    }
                }
            }

            // MARK: TYPOLOGY

            Picker(selection: $selectedType, content: {
                ForEach(Reminder2.Typology.allCases, id: \.self) {
                    Text($0.rawValue)
                        .font(Typography.headerM)
                }
            }, label: {
                CategoryRow(title: String(localized: "Based on"), icon: .basedOn, color: Palette.colorOrange)
            })

            switch selectedType {
            case .date:
                DatePicker(
                    selection: $reminder.date,
                    in: Date() ... Calendar.current.date(byAdding: .year, value: 4, to: Date())!
                ) {
                    CategoryRow(
                        title: String(localized: "Remind me on"),
                        icon: .remindMe,
                        color: Palette.colorGreen
                    )
                    .padding(.bottom, 10)
                }
                .datePickerStyle(.compact)
//            default:
//                HStack {
//                    CategoryRow(title: String(localized: "Remind me in"), icon: .remindMe, color: Palette.colorGreen)
//                    Spacer()
//                    TextField("1000", value: $reminderVM.distance, formatter: NumberFormatter())
//                        .font(Typography.headerM)
//                        .foregroundColor(Palette.black)
//                        .textFieldStyle(.plain)
//                        .keyboardType(.decimalPad)
//                        .fixedSize(horizontal: true, vertical: true)
//                    Text(utilityVM.unit)
//                        .font(Typography.headerM)
//                        .foregroundColor(Palette.black)
//                }
            }

            // TODO: Implement REPEAT

//            Picker(selection: $addExpVM.selectedRepeat, content: {
//                ForEach(addExpVM.repeatTypes, id: \.self) {
//                    Text($0)
//                        .font(Typography.headerM)
//                }
//            }, label:{
//                ListCategoryComponent(title: "Repeat", iconName: "Repeat", color: Palette.colorViolet)
//            })
//            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: NOTE

            HStack {
                ZStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundColor(reminder.note.isEmpty ? Palette.greyLight : Palette.colorViolet)
                    Image(reminder.note.isEmpty ? .note : .noteColored)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                TextField(String(localized: "Note"), text: $reminder.note)
                    .disableAutocorrection(true)
                    .focused(focusedField, equals: .note)
                    .font(Typography.headerM)
            }
        }
        .padding(.top, -10)
        // TODO: Check what this does
        .onAppear {
            /// Setting the keyboard focus on the price when opening the modal
            if reminderVM.title.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { /// Anything over 0.5 delay seems to work
                    focusedField.wrappedValue = .reminderTab
                }
            }
        }
    }
}
