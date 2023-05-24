//
//  CoreDataManager.swift
//  Hurricane
//
//  Created by Asya Tealdi on 03/05/22.
//

import CoreData
import Foundation

// FIX: Add error handling
class CoreDataManager {
    // Singleton
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext

    init() {
        container = NSPersistentContainer(name: "CarModel")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to initialize Core Data \(error)")
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

    func getEntityBy(id: NSManagedObjectID) -> NSManagedObject? {
        do {
            return try context.existingObject(with: id)
        } catch {
            print(error)
            return nil
        }
    }

    func delete(entity: NSManagedObject) {
        context.delete(entity)

        do {
            try context.save()
            print("\(entity.entity) deleted successfully")
        } catch {
            context.rollback()
            print("Failed to delete \(entity.entity) with \(error)")
        }
    }
}
