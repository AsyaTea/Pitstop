//
//  CoreDataManager.swift
//  Hurricane
//
//  Created by Asya Tealdi on 03/05/22.
//

import CoreData
import Foundation

class CoreDataManager {
    // Singleton
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext

    init() {
        container = NSPersistentContainer(name: "CarModel")
        container.loadPersistentStores { _, error in
            if let error {
                print("Error loading Core Data: \(error)")
            }
        }
        context = container.viewContext
    }

    func save() {
        do {
            try context.save()
        } catch {
            print("Error saving Core Data. \(error.localizedDescription)")
        }
    }

    func removeAllItems(deleteRequest: NSBatchDeleteRequest) {
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print("Error when removing all Items:\(error.localizedDescription)")
        }
    }

    func getVehicleById(id: NSManagedObjectID) -> Vehicle? {
        do {
            return try context.existingObject(with: id) as? Vehicle
        } catch {
            print(error)
            return nil
        }
    }

    func getExpenseById(id: NSManagedObjectID) -> Expense? {
        do {
            return try context.existingObject(with: id) as? Expense
        } catch {
            print(error)
            return nil
        }
    }

    func getNumberById(id: NSManagedObjectID) -> Number? {
        do {
            return try context.existingObject(with: id) as? Number
        } catch {
            print(error)
            return nil
        }
    }

    func getReminderById(id: NSManagedObjectID) -> Reminder? {
        do {
            return try context.existingObject(with: id) as? Reminder
        } catch {
            print(error)
            return nil
        }
    }

    func delete(entity: NSManagedObject) {
        context.delete(entity)

        do {
            try context.save()
        } catch {
            context.rollback()
            print("Failed to delete \(entity.entity) with \(error)")
        }
    }

}
