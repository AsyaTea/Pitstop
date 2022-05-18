
import Foundation
import CoreData

enum VehicleError: Error {
    case VehicleNotFount
}

class DataViewModel : ObservableObject {
    
    let manager = CoreDataManager.instance
    
    // Vehicle
    @Published var vehicleList : [VehicleViewModel] = []   //Var to store all the fetched vehicle entities
    @Published var currVehicle = Vehicle() /// da togliere
    
    
    @Published var currentVehicle : [VehicleViewModel] = []
    
    //Expense
    @Published var expenses : [Expense] = []
    @Published var expenseModel = ExpenseModel()
    
    //Filter
    @Published var filter : NSPredicate?
    
    init() {
        getVehiclesCoreData(filter:nil, storage: {storage in
            self.vehicleList = storage
        })
    }
    
    //    func getVehicleID(id : UUID){
    //        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
    //        let filter = NSPredicate(format: "vehicleID == %@", id as CVarArg)
    //        request.predicate = filter
    //
    //        do {
    //             currentVehicle =  try manager.context.fetch(request)
    //        }catch let error {
    //            print("🚓 Error fetching the vehicle ID: \(error.localizedDescription)")
    //        }
    //
    //    }
    
    
    
    //MARK: VEHICLE FUNCTIONS
    func getVehiclesCoreData(filter : NSPredicate?, storage: @escaping([VehicleViewModel]) -> ())  {
        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
        let vehicle : [Vehicle]
        
        let sort = NSSortDescriptor(keyPath: \Vehicle.objectID, ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = filter
        
        do {
            vehicle =  try manager.context.fetch(request)
            DispatchQueue.main.async{
                storage(vehicle.map(VehicleViewModel.init))
            }
            
        }catch let error {
            print("🚓 Error fetching vehicles: \(error.localizedDescription)")
        }
    }
    
    func setAllCurrentToFalse() {
        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
        let vehicle : [Vehicle]
        let filter = NSPredicate(format: "current == %@","1") // trovo tutti i veicoli che sono a true
        request.predicate = filter
        do {
            vehicle =  try manager.context.fetch(request)
            vehicle.first?.current = 0
        }
        catch let error {
            print("🚓 Error fetching vehicles: \(error.localizedDescription)")
        }
        saveVehicle()

    }
    
    
//    func getCurrentVehicle() {
//        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
//        let vehicle : [Vehicle]
//
//        let filter = NSPredicate(format: "current == %@","1")
//        request.predicate = filter
//
//        do {
//            vehicle =  try manager.context.fetch(request)
//            DispatchQueue.main.async{
//                self.currentVehicle = vehicle.map(VehicleViewModel.init)
//            }
//            print("CURRENT VEHICLE LIST ",vehicleList)
//
//        }catch let error {
//            print("🚓 Error fetching current vehicle: \(error.localizedDescription)")
//        }
//    }
    
    
//    func getVehicles() {
//
//        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
//        let vehicle : [Vehicle]
//
//        //Sort for ID
//        let sort = NSSortDescriptor(keyPath: \Vehicle.objectID, ascending: true)
//        request.sortDescriptors = [sort]
//
//        //Filter if needed, ad esempio qua filtro per veicoli a benzina
//        //        let filter = NSPredicate(format: "fuelType == %@", "1")
//
//        do {
//            vehicle =  try manager.context.fetch(request)
//            DispatchQueue.main.async{
//                self.vehicleList = vehicle.map(VehicleViewModel.init)
//            }
//            print("VEHICLE LIST ",vehicleList)
//
//        }catch let error {
//            print("🚓 Error fetching vehicles: \(error.localizedDescription)")
//        }
//    }
    
    func addVehicle(vehicle : VehicleState) {
        let newVehicle = Vehicle(context: manager.context)
        newVehicle.name = vehicle.name
        newVehicle.brand = vehicle.brand
        newVehicle.model = vehicle.model // etc
        
        self.vehicleList.append(VehicleViewModel(vehicle: newVehicle)) //Add the new vehicle to the list 
        saveVehicle()
        
    }
    
    
    //In case we need it
    func removeAllVehicles() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Vehicle")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        manager.removeAllItems(deleteRequest: deleteRequest)
        saveVehicle()
        self.vehicleList.removeAll()
        
    }
    
    //    func removeVehicle(indexSet: IndexSet) {
    //        guard let index = indexSet.first else { return }
    //        let entity = vehicleList[index]
    //        manager.container.viewContext.delete(entity)
    //        saveVehicle()
    //    }
    
    func deleteVehicleCoreData(vehicle : VehicleViewModel) {
        let vehicle = manager.getVehicleById(id: vehicle.vehicleID)
        if let vehicle = vehicle {
            manager.deleteVehicle(vehicle)
        }
        saveVehicle()
    }
    
    func deleteVehicle(at indexSet: IndexSet){
        indexSet.forEach{ index in
            let vehicle = vehicleList[index]
            vehicleList.remove(at: index)
            deleteVehicleCoreData(vehicle: vehicle)
        }
    }
    
    
    //MARK: TODOOOOO

    func updateVehicle(_ vs : VehicleState) throws{
        
        guard let vehicleID = vs.vehicleID else {
            return print("Vehicle ID not found during update")
        }
        
        guard let vehicle = manager.getVehicleById(id: vehicleID) else {
            return print("Vehicle not found during update")
        }
        
        vehicle.name = vs.name
        vehicle.brand = vs.brand
        vehicle.model = vs.model
        vehicle.current = vs.current
       //etc etc
        
        //PUBLISHED LIST UPDATE
        for (index,value) in vehicleList.enumerated() {
            if(value.vehicleID == vs.vehicleID){
            vehicleList.remove(at: index)
            vehicleList.insert(VehicleViewModel(vehicle: vehicle), at: index)
            }
        }
        
        saveVehicle()
        print("UPDATE DONE")
    }
    
    func getVehicleById(vehicleId : NSManagedObjectID) throws -> VehicleViewModel {
        
        guard let vehicle = manager.getVehicleById(id: vehicleId) else {
            throw VehicleError.VehicleNotFount // DA FIXARE
        }
        
        let vehicleVM = VehicleViewModel(vehicle: vehicle)
        return vehicleVM
    }
    
    
    func saveVehicle() {
        manager.save()
    }
    
    
    
    //MARK: EXPENSE FUNCTIONS
    func getExpenses(filter : NSPredicate?){
        
        let request = NSFetchRequest<Expense>(entityName: "Expense")
        request.predicate = filter
        
        do {
            expenses =  try manager.context.fetch(request)
        }catch let error {
            print("💰 Error fetching expenses: \(error.localizedDescription)")
        }
    }
    
    func addExpense(expense : ExpenseModel) {
        let newExpense = Expense(context: manager.context)
        newExpense.vehicle = currVehicle
        print(" Expense : \(expense)")
        saveExpense()
    }
    
    func removeExpense(indexSet: IndexSet) {
        
        guard let index = indexSet.first else { return }
        let entity = expenses[index]
        manager.container.viewContext.delete(entity)
        saveExpense()
    }
    
    func removeAllExpenses() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Expense")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        manager.removeAllItems(deleteRequest: deleteRequest)
        getExpenses(filter: filter)
    }
    
    func saveExpense() {
        manager.save()
        getExpenses(filter: filter)
    }
    
}


struct VehicleViewModel : Hashable {
    
    let vehicle : Vehicle
    
    var current: NSNumber {
        return vehicle.current ?? 0
    }
    
    var brand : String {
        return vehicle.brand ?? ""
    }
    
    //    var document : Data {
    //        return vehicle.date
    //    }
    
    var fuelType: Int32{
        return vehicle.fuelType
    }
    
    var model : String{
        return vehicle.model ?? ""
    }
    
    var name : String {
        return vehicle.name ?? ""
    }
    
    var odometer : Int16{
        return vehicle.odometer
    }
    
    var plate : String {
        return vehicle.plate ?? "Not specified"
    }
    
    var vehicleID: NSManagedObjectID {
        return vehicle.objectID
    }
    
    var year: Int16 {
        return vehicle.year
    }
}

struct ExpenseModel {
    var date : Date?
    var isRecursive : Bool?
    var note : String?
    var odometer : Int32?
    var price : Float?
    var type : Int16? // Enum
    
}

struct VehicleState : Hashable {
    
    var current : NSNumber?
    var brand : String = ""
    var document : Data?
    var fuelType: Int32?
    var model : String = ""
    var name : String = ""
    var odometer : Int16?
    var plate : String = ""
    var vehicleID: NSManagedObjectID?
    var year: Int16?
}

extension VehicleState {
    
    static func fromVehicleViewModel(vm: VehicleViewModel) -> VehicleState{
        var vehicleS = VehicleState()
        vehicleS.current = vm.current
        vehicleS.vehicleID = vm.vehicleID
        vehicleS.odometer = vm.odometer
        vehicleS.brand = vm.brand
        vehicleS.fuelType = vm.fuelType
        vehicleS.name = vm.name
        vehicleS.year = vm.year
        vehicleS.model = vm.model
        vehicleS.plate = vm.plate
        return vehicleS
    }
    
}


