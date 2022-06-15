//
//  ReminderViewModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 03/06/22.
//

import Foundation

class AddReminderViewModel : ObservableObject {
    
    @Published var reminderS = ReminderState()
    
    //Vars for the input fields of reminder
    @Published var title = ""
    @Published var note = ""
    @Published var distance = ""
    @Published var date = Date.now
    
    @Published var selectedCategory = String(localized: "Maintenance")
    @Published var category : Int16 = Int16(Category.fuel.rawValue)

    //MARK: CATEGORY MISSING TO FIX
    
    func createReminder() {
        reminderS.title = title
        reminderS.note = note
        reminderS.distance = distance
        reminderS.date = date
        reminderS.category = category
    }
    
    func resetReminderFields(tab: String){
        title = ""
        note = ""
        distance = ""
        category = 1
        selectedCategory = String(localized: "Maintenance")
        date = Date.now
    }
    
    
}
