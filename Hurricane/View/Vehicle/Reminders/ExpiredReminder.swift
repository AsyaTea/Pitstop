//
//  ExpiredReminder.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 11/06/22.
//

import SwiftUI

struct ExpiredReminder: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var dataVM: DataViewModel
    @StateObject var utilityVM: UtilityViewModel
    @StateObject var notificationVM = NotificationManager()
    
    var body: some View {
        VStack{
            ReminderList(utilityVM: utilityVM)
                .disabled(true)
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
                        
                        Text(String(localized: "Back"))
                            .font(Typography.headerM)
                    }
                })
                .accentColor(Palette.greyHard)
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(String(localized: "View reminder"))
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
        }
    }
}


