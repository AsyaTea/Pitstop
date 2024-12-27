//
//  Number+CoreDataProperties.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//
//

import CoreData
import Foundation

public extension Number {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Number> {
        NSFetchRequest<Number>(entityName: "Number")
    }

    @NSManaged var telephone: String?
    @NSManaged var title: String?
    @NSManaged var vehicle: Vehicle?
}

extension Number: Identifiable {}
