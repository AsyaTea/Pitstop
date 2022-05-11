
import Foundation
import CoreData

class DataViewModel : ObservableObject {
    
    let manager = CoreDataManager.instance

    // Vehicle
    @Published var vehicleModel = VehicleModel() 
    @Published var vehicles : [Vehicle] = []   //Var to store all the fetched vehicle entities
    @Published var currVehicle = Vehicle()
    
    //Expense
    @Published var expenses : [Expense] = []
    @Published var expenseModel = ExpenseModel()
    
    //Filter
    @Published var filter : NSPredicate?
    
    init() {
        getVehicles()
        getExpenses(filter: filter)
    }
    
    
    //MARK: VEHICLE FUNCTIONS
    func getVehicles() {
        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
        
        //Sort for ID
        let sort = NSSortDescriptor(keyPath: \Vehicle.vehicleID, ascending: true)
        request.sortDescriptors = [sort]
        
        //Filter if needed, ad esempio qua filtro per veicoli a benzina
//        let filter = NSPredicate(format: "fuelType == %@", "1")
    
        do {
            vehicles =  try manager.context.fetch(request)
        }catch let error {
            print("🚓 Error fetching vehicles: \(error.localizedDescription)")
        }
    }
    
    func addVehicle(vehicle : VehicleModel) {
        let newVehicle = Vehicle(context: manager.context)
        newVehicle.name = vehicle.name
        newVehicle.brand = vehicle.brand
        newVehicle.model = vehicle.model
        print(newVehicle)
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
    
    func setCurrentVehicle(currVehicle: Vehicle) {
        self.currVehicle = currVehicle
        print(self.currVehicle.name ?? "")
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
        newExpense.name = expense.name
        newExpense.vehicle = currVehicle
        print(expense)
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


struct VehicleModel : Hashable {
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

struct ExpenseModel {
    var date : Date?
    var isRecursive : Bool?
    var name : String?
    var note : String?
    var odometer : Int32?
    var price : Float?
    var type : Int16? // Enum
    
}
