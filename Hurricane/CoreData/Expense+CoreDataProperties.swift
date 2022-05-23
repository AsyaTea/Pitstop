//
//  Expense+CoreDataProperties.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var date: Date
    @NSManaged public var note: String?
    @NSManaged public var odometer: Float
    @NSManaged public var price: Float
    @NSManaged public var category: Int16
    @NSManaged public var fuelType: Int16
    @NSManaged public var liters: Float
    @NSManaged public var priceLiter: Float
    @NSManaged public var vehicle: Vehicle?

}

extension Expense : Identifiable {

}
