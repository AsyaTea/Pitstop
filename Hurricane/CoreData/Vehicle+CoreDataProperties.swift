//
//  Vehicle+CoreDataProperties.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//
//

import Foundation
import CoreData


extension Vehicle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vehicle> {
        return NSFetchRequest<Vehicle>(entityName: "Vehicle")
    }

    @NSManaged public var current: NSNumber?
    @NSManaged public var brand: String?
    @NSManaged public var document: Data?
    @NSManaged public var fuelTypeOne: Int32
    @NSManaged public var fuelTypeTwo: Int32
    @NSManaged public var model: String?
    @NSManaged public var name: String?
    @NSManaged public var odometer: Float
    @NSManaged public var plate: String?
    @NSManaged public var year: Int32
    @NSManaged public var expenses: NSSet?

}

// MARK: Generated accessors for expenses
extension Vehicle {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

extension Vehicle : Identifiable {

}
