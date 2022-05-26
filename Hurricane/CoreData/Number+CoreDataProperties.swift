//
//  Number+CoreDataProperties.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//
//

import Foundation
import CoreData


extension Number {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Number> {
        return NSFetchRequest<Number>(entityName: "Number")
    }

    @NSManaged public var telephone: String?
    @NSManaged public var title: String?
    @NSManaged public var vehicle: Vehicle?

}

extension Number : Identifiable {

}
