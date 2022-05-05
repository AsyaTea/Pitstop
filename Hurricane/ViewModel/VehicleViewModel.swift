
import Foundation
import CoreData

class VehicleViewModel : ObservableObject {
    
    let manager = CoreDataManager.instance

    // Vehicle
    @Published var vehicleModel = VehicleModel() 
    @Published var vehicles : [Vehicle] = []   //Var to store all the fetched vehicle entities
    @Published var currVehicle = Vehicle()
    
    //Expense
    @Published var expenses : [Expense] = []
    @Published var expenseModel = ExpenseModel()
    
    init() {
        getVehicles()
        getExpenses()
    }
    
    
    //MARK: VEHICLE FUNCTIONS
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
            print("🚓 Error fetching vehicles: \(error.localizedDescription)")
        }
    }
    
    func addVehicle(vehicle : VehicleModel) {
        let newVehicle = Vehicle(context: manager.context)
        newVehicle.name = vehicle.name
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
    
    
    //MARK: EXPENSE FUNCTIONS
    func getExpenses (){
        let request = NSFetchRequest<Expense>(entityName: "Expense")
        
        do {
            expenses =  try manager.context.fetch(request)
        }catch let error {
            print("💰 Error fetching expenses: \(error.localizedDescription)")
        }
    }
    
    func addExpense(expense : ExpenseModel) {
        let newExpense = Expense(context: manager.context)
        newExpense.name = expense.name
        currVehicle.addToExpenses(newExpense)
        saveExpense()
    }
    
    
    func saveExpense() {
        manager.save()
        getExpenses()
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

struct ExpenseModel {
    var date : Date?
    var isRecursive : Bool?
    var name : String?
    var note : String?
    var odometer : Int32?
    var price : Float?
    var type : Int16? // Enum
    
}
