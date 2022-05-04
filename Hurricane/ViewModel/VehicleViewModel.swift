
import Foundation
import CoreData

class VehicleViewModel : ObservableObject {
    
    let manager = CoreDataManager.instance
    @Published var name : String = ""
    @Published var vehicles : [Vehicle] = []
    
   
    
    init() {
        getVehicles()
    }
    
    func getVehicles() {
        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
        
        //Sort for ID
        let sort = NSSortDescriptor(keyPath: \Vehicle.vehicleID, ascending: true)
        request.sortDescriptors = [sort]
        
        //Filter if needed, ad esempio qua filtro per veicoli a benzina
//        let filter = NSPredicate(format: "fuelType == %@", "1")
//        request.predicate = filter

        
        do {
            vehicles =  try manager.context.fetch(request)
        }catch let error {
            print("😵 Error fetching: \(error.localizedDescription)")
        }
    }
    
    func addVehicle() {
        let newVehicle = Vehicle(context: manager.context)
        newVehicle.name = name
        newVehicle.fuel = .diesel
        saveVehicle()
        
    }
    
    //In case we need it
    func removeAllVehicles() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Vehicle")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        manager.removeAllItems(deleteRequest: deleteRequest)
        getVehicles()
    }

    
    func saveVehicle() {
        manager.save()
        getVehicles()
    }
    
}

