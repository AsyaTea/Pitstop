
import Foundation
import CoreData

class VehicleViewModel : ObservableObject {
    
    let manager = CoreDataManager.instance

    @Published var vehicleModel = VehicleModel()
    @Published var vehicles : [Vehicle] = []
    
    init() {
        getVehicles()
    }
    
    func getVehicles() {
        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
        
        //Sort for ID
        let sort = NSSortDescriptor(keyPath: \Vehicle.vehicleID, ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            vehicles =  try manager.context.fetch(request)
        }catch let error {
            print("😵 Error fetching: \(error.localizedDescription)")
        }
    }
    
    func addVehicle(vehicle : VehicleModel) {
        let newVehicle = Vehicle(context: manager.context)
        newVehicle.name = vehicle.name
        saveVehicle()
        
    }
    
    //In case we need it
    func removeAllVehicles() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Vehicle")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        manager.removeAllItems(deleteRequest: deleteRequest)
        getVehicles()
    }
    
    func removeVehicle(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = vehicles[index]
        manager.container.viewContext.delete(entity)
        saveVehicle()
    }
    
    //MARK: TODOOOOO
    func updateVehicle(entity: Vehicle, vehicleUpdate: VehicleModel) {
        entity.name = vehicleUpdate.name
        saveVehicle()
    }

    
    func saveVehicle() {
        manager.save()
        getVehicles()
    }
    
}

struct VehicleModel {
    var brand : String?
    var document : Data?
    var fuelType: Int32?
    var model : String?
    var name : String?
    var odometer : Int16?
    var plate : String?
    var vehicleID: UUID?
    var year: Int16?
}
