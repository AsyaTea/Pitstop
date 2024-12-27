//
//  ReminderModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 03/06/22.
//

import CoreData
import Foundation

struct ReminderState: Hashable {
    var title: String = ""
    var category: Int16?
    var based: Int16?
    var recurrence: Int16?
    var note: String = ""
    var date: Date = .now
    var distance: String = ""
    var reminderID: NSManagedObjectID?
}

struct ReminderViewModel: Hashable, Comparable {
    static func < (lhs: ReminderViewModel, rhs: ReminderViewModel) -> Bool {
        lhs.date < rhs.date
    }

    let reminder: Reminder

    var title: String {
        reminder.title ?? ""
    }

    var category: Int16 {
        reminder.category
    }

    var based: Int16 {
        reminder.based
    }

    var recurrence: Int16 {
        reminder.recurrence
    }

    var note: String {
        reminder.note ?? ""
    }

    var date: Date {
        reminder.date
    }

    var distance: String {
        reminder.distance ?? ""
    }

    var reminderID: NSManagedObjectID {
        reminder.objectID
    }
}

extension ReminderState {
    static func fromReminderViewModel(vm: ReminderViewModel) -> ReminderState {
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
