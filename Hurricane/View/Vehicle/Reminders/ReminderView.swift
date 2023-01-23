//
//  RemindersList.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 03/06/22.
//

import SwiftUI

struct ReminderView: View {
    @ObservedObject var dataVM: DataViewModel
    @StateObject var utilityVM: UtilityViewModel
    @Environment(\.presentationMode) private var presentationMode

    @State private var showEditReminder = false
    @State private var showExpiredReminder = false

    let filterExpiredReminders = NSPredicate(format: "date <= %@", NSDate())
    let filterFutureReminders = NSPredicate(format: "date > %@", NSDate())

    var body: some View {
        NavigationView {
            ZStack {
                Palette.greyBackground
                    .ignoresSafeArea()
                VStack {
                    // MARK: - FILTERS TO DO

                    ScrollView(.vertical, showsIndicators: false) {
                        // MARK: - FUTURE

                        ZStack {
                            Rectangle()
                                .frame(height: UIScreen.main.bounds.height * 0.035)
                                .foregroundColor(Palette.greyLight)
                            HStack {
                                Text("Future")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.ControlS)
                                Spacer()
                            }
                            .padding()
                        }

                        if dataVM.reminderList.isEmpty {
                            HStack {
                                Text("There are no reminders now")
                                    .font(Typography.TextM)
                                    .foregroundColor(Palette.greyMiddle)
                                Spacer()
                            }
                            .padding()
                        }

                        // MARK: - REMINDERS LIST

                        ForEach(dataVM.reminderList.sorted(), id: \.self) { reminder in
                            Button(action: {
                                showEditReminder.toggle()
                                utilityVM.reminderToEdit = ReminderState.fromReminderViewModel(vm: reminder)
                            }, label: {
                                ReminderComponent(
                                    reminder: reminder,
                                    category: Category(rawValue: Int(reminder.category)) ?? .other,
                                    expired: false
                                )
                            })
                        }

                        // MARK: - EXPIRED

                        ZStack {
                            Rectangle()
                                .frame(height: UIScreen.main.bounds.height * 0.035)
                                .foregroundColor(Palette.greyLight)
                            HStack {
                                Text("Expired")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.ControlS)
                                Spacer()
                            }
                            .padding()
                        }

                        if dataVM.expiredReminders.isEmpty {
                            HStack {
                                Text("There are no reminders now")
                                    .font(Typography.TextM)
                                    .foregroundColor(Palette.greyMiddle)
                                Spacer()
                            }
                            .padding()
                        }

                        // MARK: - EXPIRED REMINDER

                        ForEach(dataVM.expiredReminders.reversed(), id: \.self) { reminder in
                            Button(action: {
                                showExpiredReminder.toggle()
                                utilityVM.reminderToEdit = ReminderState.fromReminderViewModel(vm: reminder)
                            }, label: {
                                ReminderComponent(
                                    reminder: reminder,
                                    category: Category(rawValue: Int(reminder.category)) ?? .other,
                                    expired: true
                                )
                            })
                        }

                        // MARK: - NAVIGATE TO EDIT

                        NavigationLink(destination: EditReminderView(dataVM: dataVM, utilityVM: utilityVM), isActive: $showEditReminder) {}
                        NavigationLink(destination: ExpiredReminder(dataVM: dataVM, utilityVM: utilityVM), isActive: $showExpiredReminder) {}
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .font(Typography.headerM)
                })
                .accentColor(Palette.greyHard),
                trailing:
                Button(action: {
                    dataVM.removeExpiredReminders()
                }, label: {
                    Text("Clear expired")
                        .font(Typography.headerM)
                })
                .accentColor(Palette.greyHard)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Reminders")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
            .onAppear {
                dataVM.getRemindersCoreData(filter: filterFutureReminders, storage: { storage in
                    dataVM.reminderList = storage
                })

                dataVM.getRemindersCoreData(filter: filterExpiredReminders, storage: { storage in
                    dataVM.expiredReminders = storage
                })
            }
        }
    }
}

// struct RemindersList_Previews: PreviewProvider {
//    static var previews: some View {
//        RemindersList()
//    }
// }

struct ReminderComponent: View {
    var reminder: ReminderViewModel
    var category: Category
    var expired: Bool

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(expired ? Palette.greyInput : category.color)
                Image(category.icon)
                    .resizable()
                    .saturation(expired ? 0 : 1)
                    .frame(width: 16, height: 16)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(reminder.title)
                        .foregroundColor(expired ? Palette.greyMiddle : Palette.black)
                        .font(Typography.headerS)
                    Spacer()
                    if reminder.based == 0 {
                        Text(reminder.date.toString(dateFormat: "MMM d, EEEE"))
                            .foregroundColor(expired ? Palette.greyMiddle : Palette.greyHard)
                            .font(Typography.headerS)
                            .padding(.trailing, -10)
                    } else {
                        Text(reminder.distance)
                            .foregroundColor(expired ? Palette.greyMiddle : Palette.greyHard)
                            .font(Typography.headerS)
                            .padding(.trailing, -10)
                    }
                }
                Text(category.label)
                    .foregroundColor(Palette.greyMiddle)
                    .font(Typography.TextM)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
