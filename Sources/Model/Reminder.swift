//
//  Reminder.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 27/12/24.
//

import Foundation
import SwiftData

@Model
final class Reminder2: Identifiable {
    // Properties
    var title: String?
    var category: Int16
    var based: Int16
    var recurrence: Int16
    var note: String?
    var date: Date
    var distance: String?

    // Initializer
    init(
        title: String? = nil,
        category: Int16,
        based: Int16,
        recurrence: Int16,
        note: String? = nil,
        date: Date,
        distance: String? = nil
    ) {
        self.title = title
        self.category = category
        self.based = based
        self.recurrence = recurrence
        self.note = note
        self.date = date
        self.distance = distance
    }
}
