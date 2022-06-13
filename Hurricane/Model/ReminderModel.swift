//
//  ReminderModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 03/06/22.
//

import Foundation
import CoreData


struct ReminderState: Hashable {
    var title: String = ""
    var category: Int16?
    var based: Int16?
    var recurrence: Int16?
    var note: String = ""
    var date: Date = Date.now
    var distance: String = ""
    var reminderID: NSManagedObjectID?
}

struct ReminderViewModel: Hashable,Comparable{
    static func < (lhs: ReminderViewModel, rhs: ReminderViewModel) -> Bool {
        lhs.date < rhs.date
    }
    
    let reminder: Reminder
    
    var title: String {
        return reminder.title ?? ""
    }
    
    var category: Int16 {
        return reminder.category
    }

    var based: Int16 {
        return reminder.based
        
    }

    var recurrence: Int16 {
        return reminder.recurrence
    }

    var note: String {
        return reminder.note ?? ""
    }

    var date: Date {
        return reminder.date
    }

    var distance: String {
        return reminder.distance ?? ""
    }
    
    var reminderID: NSManagedObjectID {
        return reminder.objectID
    }
}

extension ReminderState{
    
    static func fromReminderViewModel(vm:ReminderViewModel ) -> ReminderState{
        var reminderS = ReminderState()
        reminderS.title = vm.title
        reminderS.category = vm.category
        reminderS.based = vm.based
        reminderS.recurrence = vm.recurrence
        reminderS.note = vm.note
        reminderS.date = vm.date
        reminderS.distance = vm.distance
        reminderS.reminderID = vm.reminderID
        return reminderS
    }
        
}
