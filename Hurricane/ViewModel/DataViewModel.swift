
import Foundation
import CoreData

enum VehicleError: Error {
    case VehicleNotFound
}

class DataViewModel : ObservableObject {
    
    let manager = CoreDataManager.instance
    
    // Vehicle
    @Published var vehicleList : [VehicleViewModel] = []   //Var to store all the fetched vehicle entities
    
    @Published var currentVehicle : [VehicleViewModel] = []
    
    //Expense
    @Published var expenseList : [ExpenseViewModel] = []
    @Published var expenses : [Expense] = []
    @Published var expenseModel = ExpenseState()
    
    //Filter
    @Published var filter : NSPredicate?
    
    @Published var totalVehicleCost : Float = 0.0
    @Published var totalExpense : Float = 0.0
    
    init() {
        getVehiclesCoreData(filter:nil, storage: {storage in
            self.vehicleList = storage
        })
        getExpensesCoreData(filter: nil, storage:  { storage in
            self.expenseList = storage
            self.getTotalExpense(expenses: storage)
        })
        getCurrentVehicle()
        
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
    
    
    func getCurrentVehicle() {
        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
        let vehicle : [Vehicle]
        
        let filter = NSPredicate(format: "current == %@","1")
        request.predicate = filter
        
        do {
            vehicle =  try manager.context.fetch(request)
            DispatchQueue.main.async{
                self.currentVehicle = vehicle.map(VehicleViewModel.init)
            }
            print("CURRENT VEHICLE LIST ",vehicleList)
            
        }catch let error {
            print("🚓 Error fetching current vehicle: \(error.localizedDescription)")
        }
    }
    
    
    
    
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
        newVehicle.model = vehicle.model
        newVehicle.odometer = vehicle.odometer
        newVehicle.fuelTypeOne = vehicle.fuelTypeOne
        newVehicle.fuelTypeTwo = vehicle.fuelTypeTwo ?? 0
        print("🚓🚓🚓 ",newVehicle)
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
        vehicle.plate = vs.plate
        vehicle.fuelTypeOne = vs.fuelTypeOne
        vehicle.fuelTypeTwo = vs.fuelTypeTwo ?? 7
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
            throw VehicleError.VehicleNotFound // DA FIXARE
        }
        
        let vehicleVM = VehicleViewModel(vehicle: vehicle)
        return vehicleVM
    }
    
    func getVehicle(vehicleID: NSManagedObjectID) -> Vehicle? {
        let vehicle = manager.getVehicleById(id: vehicleID)
        return vehicle
    }
    
    
    func saveVehicle() {
        manager.save()
    }
    
    
    
    //MARK: EXPENSE FUNCTIONS
    //    func getExpenses(filter : NSPredicate?){
    //
    //        let request = NSFetchRequest<Expense>(entityName: "Expense")
    //        request.predicate = filter
    //
    //        do {
    //            self.expenses =  try manager.context.fetch(request)
    //        }catch let error {
    //            print("💰 Error fetching expenses: \(error.localizedDescription)")
    //        }
    //    }
    
    func getExpenseByID(expenseID: NSManagedObjectID) throws -> ExpenseViewModel {
        guard let expense = manager.getExpenseById(id: expenseID) else {
            throw VehicleError.VehicleNotFound // DA FIXARE
        }
        
        let expenseVM = ExpenseViewModel(expense: expense)
        return expenseVM
    }
    
    func addExpense(expense : ExpenseState) {
        let newExpense = Expense(context: manager.context)
        newExpense.vehicle = getVehicle(vehicleID: currentVehicle.first!.vehicleID)
        newExpense.note = expense.note
        newExpense.price = expense.price
        newExpense.odometer = expense.odometer
        newExpense.category = expense.category ?? 0
        newExpense.date = expense.date
        print(" Expense : \(newExpense)")
        print(" Current Vehicle \(currentVehicle)")
        self.expenseList.append(ExpenseViewModel(expense: newExpense))
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
        //        getExpenses(filter: filter)
    }
    
    func getExpensesCoreData(filter : NSPredicate?, storage: @escaping([ExpenseViewModel]) -> ())  {
        let request = NSFetchRequest<Expense>(entityName: "Expense")
        let expense : [Expense]
        
        let sort = NSSortDescriptor(keyPath: \Expense.objectID, ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = filter
        
        do {
            expense =  try manager.context.fetch(request)
            DispatchQueue.main.async{
                storage(expense.map(ExpenseViewModel.init))
            }
            
        }catch let error {
            print("🚓 Error fetching vehicles: \(error.localizedDescription)")
        }
        
    }
    
    func saveExpense() {
        manager.save()
//        getExpenses(filter: filter)
    }
    
    //Total Cost functions
    
    func getTotalExpense(expenses: [ExpenseViewModel]) {
        print("expense list: \(expenses)")
        for expense in expenses {
            totalVehicleCost += expense.price
        }
        print("sum cost : \(totalVehicleCost)")
        self.totalExpense = totalVehicleCost

    }
    func addNewExpensePriceToTotal(expense: ExpenseState) {
        self.totalExpense = totalExpense + expense.price
        print("Add new expense")
    }
    
}


struct VehicleViewModel : Hashable {
    
    let vehicle : Vehicle
    
    var expense : NSSet  {
        return vehicle.expenses ?? NSSet()
    }
    
    var current: NSNumber {
        return vehicle.current ?? 0
    }
    
    var brand : String {
        return vehicle.brand ?? ""
    }
    
    //    var document : Data {
    //        return vehicle.date
    //    }
    
    var fuelTypeOne: FuelType {
        get {return FuelType.init(rawValue: Int(vehicle.fuelTypeOne)) ?? .gasoline}
        set {vehicle.fuelTypeOne = Int16(newValue.rawValue)}
    }
    
    var fuelTypeTwo: FuelType {
        get {return FuelType.init(rawValue: Int(vehicle.fuelTypeTwo)) ?? .none}
        set {vehicle.fuelTypeTwo = Int16(newValue.rawValue)}
    }
    
    var model : String{
        return vehicle.model ?? ""
    }
    
    var name : String {
        return vehicle.name ?? ""
    }
    
    var odometer : Float{
        return vehicle.odometer
    }
    
    var plate : String {
        return vehicle.plate ?? ""
    }
    
    var vehicleID: NSManagedObjectID {
        return vehicle.objectID
    }
    
    var year: Int32 {
        return vehicle.year
    }
}


struct VehicleState : Hashable {
    
    var current : NSNumber?
    var brand : String = ""
    var document : Data?
    var fuelTypeOne: Int16 = 0
    var fuelTypeTwo: Int16?
    var model : String = ""
    var name : String = ""
    var odometer : Float = 0.0
    var plate : String = ""
    var vehicleID: NSManagedObjectID?
    var year: Int32 = 0
}

extension VehicleState {
    
    static func fromVehicleViewModel(vm: VehicleViewModel) -> VehicleState{
        var vehicleS = VehicleState()
        vehicleS.current = vm.current
        vehicleS.vehicleID = vm.vehicleID
        vehicleS.odometer = vm.odometer
        vehicleS.brand = vm.brand
        vehicleS.fuelTypeOne = Int16(vm.fuelTypeOne.rawValue)
        vehicleS.fuelTypeTwo = Int16(vm.fuelTypeTwo.rawValue)
        vehicleS.name = vm.name
        vehicleS.year = vm.year
        vehicleS.model = vm.model
        vehicleS.plate = vm.plate
        return vehicleS
    }
    
}

struct ExpenseState: Hashable {
    var category: Int16?
    var date: Date = Date.now
    var note: String = ""
    var odometer: Float = 0.0
    var price: Float = 0.0
    var expenseID: NSManagedObjectID?
    
}

extension ExpenseState {
    
    static func fromExpenseViewModel(vm: ExpenseViewModel) -> ExpenseState {
        var expenseS = ExpenseState()
        expenseS.category = vm.category
        expenseS.date = vm.date
        expenseS.note = vm.note
        expenseS.odometer = vm.odometer
        expenseS.price = vm.price
        expenseS.expenseID = vm.expenseID
        return expenseS
        
    }
}

struct ExpenseViewModel: Hashable {
    let expense : Expense
    
    var category: Int16 {
        return expense.category
    }
    
    var date: Date {
        return expense.date
    }
    
    var note: String {
        return expense.note ?? ""
    }
    
    var odometer: Float {
        return expense.odometer
    }
    
    var price: Float {
        return expense.price
    }
    
    var expenseID: NSManagedObjectID {
        return expense.objectID
    }
    
}

//struct ExpenseModel {
//    var date : Date?
//    var isRecursive : Bool?
//    var note : String?
//    var odometer : Int32?
//    var price : Float?
//    var type : Int16? // Enum
//
//}
