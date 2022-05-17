//
//  CoreDataManager.swift
//  Hurricane
//
//  Created by Asya Tealdi on 03/05/22.
//

import Foundation
import CoreData

class CoreDataManager {
    //Singleton
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "CarModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data: \(error)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
        } catch let error {
            print("Error saving Core Data. \(error.localizedDescription)")
        }
    }
    
    func removeAllItems(deleteRequest : NSBatchDeleteRequest){
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print("Error when removing all Items:\(error.localizedDescription)")
        }
    }
    
    
    func getVehicleById(id: NSManagedObjectID) -> Vehicle?  {
        
        do{
            return try context.existingObject(with: id) as? Vehicle
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func deleteVehicle(_ vehicle : Vehicle) {
        context.delete(vehicle)
        
        do{
            try context.save()
        }
        catch{
            context.rollback()
            print("Failed to delete vehicle \(error)")
        }
    }
}
