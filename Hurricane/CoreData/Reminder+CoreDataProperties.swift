//
//  Reminder+CoreDataProperties.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 03/06/22.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var title: String?
    @NSManaged public var category: Int16
    @NSManaged public var based: Int16
    @NSManaged public var recurrence: Int16
    @NSManaged public var note: String?
    @NSManaged public var date: Date
    @NSManaged public var distance: String?

}

extension Reminder : Identifiable {

}
