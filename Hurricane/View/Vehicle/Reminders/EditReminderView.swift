//
//  EditReminderView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 10/06/22.
//

import SwiftUI

struct EditReminderView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var utilityVM: UtilityViewModel
    @StateObject var notificationVM = NotificationManager()
    
    @State private var showingAlert = false
    
    var body: some View {
        VStack{
            ReminderList(utilityVM: utilityVM)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack{
                        Image("arrowLeft")
                        
                        Text("Back")
                            .font(Typography.headerM)
                    }
                })
                .accentColor(Palette.greyHard),
            trailing:
                Button(action: {
                    //                    do {
                    //                        try dataVM.updateExpense(utilityVM.expenseToEdit)
                    //                    }
                    //                    catch{
                    //                        print(error)
                    //                    }
                    //                    dataVM.getTotalExpense(expenses: dataVM.expenseList)
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                        .font(Typography.headerM)
                })
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit reminder")
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
        }
        .overlay(
            VStack{
                Spacer(minLength: UIScreen.main.bounds.size.height * 0.78)
                Button(action: {
                    showingAlert.toggle()
                }, label: {
                    DeleteButton(title:"Delete reminder")
                })
                Spacer()
            }
        )
        .alert(isPresented:$showingAlert) {
            Alert(
                title: Text("Are you sure you want to delete this reminder?"),
                message: Text("There is no undo"),
                primaryButton: .destructive(Text("Delete")) {
                    dataVM.deleteReminder(reminderS: utilityVM.reminderToEdit)
                    notificationVM.removeNotification(reminderS: utilityVM.reminderToEdit)
                    dataVM.getRemindersCoreData(filter: nil, storage: { storage in
                        dataVM.reminderList = storage
                    })
                    self.presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct ReminderList: View {
    
    @ObservedObject var utilityVM : UtilityViewModel
    @FocusState var focusedField : FocusFieldReminder?
    
    var body: some View {
        List{
            //MARK: - TITLE
            HStack{
                ListCategoryComponent(title: "Title", iconName: "other", color: Palette.colorViolet)
                Spacer()
                TextField("Title", text: $utilityVM.reminderToEdit.title)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .fixedSize(horizontal: true, vertical: true)
                    .focused($focusedField, equals: .title)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = .title
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            //MARK: - NOTE
            HStack{
                ListCategoryComponent(title: "Note", iconName: "noteColored", color: Palette.colorViolet)
                Spacer()
                TextField("Note", text: $utilityVM.reminderToEdit.note)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .fixedSize(horizontal: true, vertical: true)
                    .focused($focusedField, equals: .note)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = .note
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        }
    }
}

enum FocusFieldReminder: Hashable {
    case title
    case note
}
