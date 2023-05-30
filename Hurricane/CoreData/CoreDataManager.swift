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
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext

    private init() {
        container = NSPersistentContainer(name: "CarModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved loadPersistentStores error \(error), \(error.userInfo)")
            }
        }
        context = container.viewContext
    }

    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }

    func removeAllItems(deleteRequest: NSBatchDeleteRequest) {
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
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
            print(entity.entity.managedObjectClassName ?? "", " deleted successfully")
        } catch {
            context.rollback()
            print("Failed to delete" + String(describing: entity.entity.managedObjectClassName) + " with \(error)")
        }
    }
}
