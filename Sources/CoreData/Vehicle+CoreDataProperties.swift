//
//  Vehicle+CoreDataProperties.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//
//

import CoreData
import Foundation

public extension Vehicle {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Vehicle> {
        NSFetchRequest<Vehicle>(entityName: "Vehicle")
    }

    @NSManaged var current: NSNumber?
    @NSManaged var brand: String?
    @NSManaged var fuelTypeOne: Int16
    @NSManaged var fuelTypeTwo: Int16
    @NSManaged var model: String?
    @NSManaged var name: String?
    @NSManaged var odometer: Float
    @NSManaged var plate: String?
    @NSManaged var year: Int32
    @NSManaged var expenses: NSSet?
}

// MARK: Generated accessors for expenses

public extension Vehicle {
    @objc(addExpensesObject:)
    @NSManaged func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged func removeFromExpenses(_ values: NSSet)
}

extension Vehicle: Identifiable {}
