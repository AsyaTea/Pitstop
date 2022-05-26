
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
    
    //Important number
    @Published var numberList: [NumberViewModel] = []
    
    //Filter
    @Published var filter : NSPredicate?
//    @Published var filterCurrentExpense : NSPredicate?
    
    @Published var totalVehicleCost : Float = 0.0
    @Published var totalExpense : Float = 0.0
    
    
    init() {
        getVehiclesCoreData(filter:nil, storage: {storage in
            self.vehicleList = storage
        })
        
        getNumbersCoreData(filter: nil, storage: { storage in
            self.numberList = storage
            
        })
        
//        getCurrentVehicle()

        
    }
    
    
    //MARK: VEHICLE CRUD
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
        save()
        
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
                let filterCurrentExpense = NSPredicate(format: "vehicle = %@", (self.currentVehicle.first?.vehicleID)!)
                self.getExpensesCoreData(filter: filterCurrentExpense, storage:  { storage in
                    self.expenseList = storage
                    self.getTotalExpense(expenses: storage)
                })
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
        newVehicle.plate = vehicle.plate
        newVehicle.current = vehicle.current
        newVehicle.fuelTypeOne = vehicle.fuelTypeOne
        newVehicle.fuelTypeTwo = vehicle.fuelTypeTwo ?? 0
        print("🚓🚓🚓 ",newVehicle)
        self.vehicleList.append(VehicleViewModel(vehicle: newVehicle)) //Add the new vehicle to the list
        save()
        
    }
    
    
    //In case we need it
    func removeAllVehicles() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Vehicle")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        manager.removeAllItems(deleteRequest: deleteRequest)
        save()
        self.vehicleList.removeAll()
        
    }
    
    
    func deleteVehicleCoreData(vehicle : VehicleViewModel) {
        let vehicle = manager.getVehicleById(id: vehicle.vehicleID)
        if let vehicle = vehicle {
            manager.deleteVehicle(vehicle)
        }
        save()
    }
    
    func deleteVehicle(at indexSet: IndexSet){
        indexSet.forEach{ index in
            let vehicle = vehicleList[index]
            vehicleList.remove(at: index)
            deleteVehicleCoreData(vehicle: vehicle)
        }
    }
    
        
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
        
        save()
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
    
    
    func save() {
        manager.save()
    }
    
    
    
    //MARK: EXPENSE CRUD

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
        newExpense.fuelType = expense.fuelType ?? 0
        newExpense.liters = expense.liters ?? 0.0
        newExpense.priceLiter = expense.priceLiter ?? 1.0
        newExpense.vehicle?.odometer += expense.odometer
        print(" Expense : \(newExpense)")
        print(" Current Vehicle \(currentVehicle)")
        self.expenseList.append(ExpenseViewModel(expense: newExpense))
        save()
    }
    
    func removeExpense(indexSet: IndexSet) {
        
        guard let index = indexSet.first else { return }
        let entity = expenses[index]
        manager.container.viewContext.delete(entity)
        save()
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
            print("💰 Error fetching expenses: \(error.localizedDescription)")
        }
    }
    
    //MARK: IMPORTANT NUMBERS CRUD
    
    func getNumbersCoreData(filter : NSPredicate?, storage: @escaping([NumberViewModel]) -> ())  {
        let request = NSFetchRequest<Number>(entityName: "Number")
        let expense : [Number]
        
        let sort = NSSortDescriptor(keyPath: \Number.objectID, ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = filter
        
        do {
            expense =  try manager.context.fetch(request)
            DispatchQueue.main.async{
                storage(expense.map(NumberViewModel.init))
            }
            
        }catch let error {
            print("🔢 Error fetching numbers: \(error.localizedDescription)")
        }
    }
    
    func addNumber(number : NumberState) {
        let newNumber = Number(context: manager.context)
        newNumber.vehicle = getVehicle(vehicleID: currentVehicle.first!.vehicleID)
        newNumber.telephone = number.telephone
        newNumber.title = number.title
        
        print(" Number : \(newNumber)")
        print(" Current Vehicle \(currentVehicle)")
        self.numberList.append(NumberViewModel(number: newNumber))
        save()
    }
    
    
    //Total Cost functions
    // Move somewhere else
    func getTotalExpense(expenses: [ExpenseViewModel]) {
        print("expense list: \(expenses)")
        self.totalVehicleCost = 0
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
