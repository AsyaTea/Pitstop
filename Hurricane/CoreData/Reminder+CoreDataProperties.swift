//
//  Reminder+CoreDataProperties.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 03/06/22.
//
//

import CoreData
import Foundation

public extension Reminder {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Reminder> {
        NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged var title: String?
    @NSManaged var category: Int16
    @NSManaged var based: Int16
    @NSManaged var recurrence: Int16
    @NSManaged var note: String?
    @NSManaged var date: Date
    @NSManaged var distance: String?
}

extension Reminder: Identifiable {}
