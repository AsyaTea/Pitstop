//
//  RemindersList.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 03/06/22.
//

import SwiftUI

struct RemindersList: View {
    
    @StateObject var dataVM: DataViewModel
    @StateObject var utilityVM: UtilityViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var showEditReminder = false
    
    var body: some View {
        NavigationView{
            ZStack{
                Palette.greyBackground
                    .ignoresSafeArea()
                VStack{
                    //MARK: - FILTERS TO DO
                    ScrollView(.vertical,showsIndicators: false){
                        if dataVM.reminderList.isEmpty {
                            HStack{
                                Text("There are no reminders now")
                                    .font(Typography.TextM)
                                    .foregroundColor(Palette.greyMiddle)
                                Spacer()
                            }
                            .padding()
                        }
                        
                        //MARK: - FUTURE
                        ZStack{
                            Rectangle()
                                .frame(height: UIScreen.main.bounds.height * 0.035)
                                .foregroundColor(Palette.greyLight)
                            HStack{
                                Text("Future")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.ControlS)
                                Spacer()
                            }
                            .padding()
                        }
                        
                        //MARK: - REMINDERS LIST
                        ForEach(dataVM.reminderList.reversed(),id:\.self){reminder in
                            Button(action: {
                                showEditReminder.toggle()
                                utilityVM.reminderToEdit = ReminderState.fromReminderViewModel(vm: reminder)
                            }, label: {
                                CategoryComponent(
                                    category: Category.init(rawValue: Int(reminder.category )) ?? .other,
                                    date: reminder.date, cost: String(reminder.title)
                                )
                            })

                        }
                        
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
                    .accentColor(Palette.greyHard)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Reminders")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
            .onAppear{
                dataVM.getRemindersCoreData(filter: nil, storage: { storage in
                    dataVM.reminderList = storage
                })
            }
        }
    }
}

//struct RemindersList_Previews: PreviewProvider {
//    static var previews: some View {
//        RemindersList()
//    }
//}
