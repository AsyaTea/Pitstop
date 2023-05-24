
import CoreData
import Foundation

enum VehicleError: Error {
    case VehicleNotFound
}

// swiftlint:disable type_body_length

class DataViewModel: ObservableObject {
    let manager = CoreDataManager.instance

    // Vehicle
    @Published var vehicleList: [VehicleViewModel] = [] // Var to store all the fetched vehicle entities
    @Published var currentVehicle: [VehicleViewModel] = []

    // Expense
    @Published var expenseList: [ExpenseViewModel] = []
    @Published var expenses: [Expense] = []
    @Published var expenseModel = ExpenseState()

    // Important number
    @Published var numberList: [NumberViewModel] = []

    // Reminder
    @Published var reminderList: [ReminderViewModel] = []
    @Published var expiredReminders: [ReminderViewModel] = []

    // Filter
    @Published var filter: NSPredicate?
    //    @Published var filterCurrentExpense : NSPredicate?

    @Published var totalVehicleCost: Float = 0.0
    @Published var totalExpense: Float = 0.0
    @Published var monthsAmount: Set<String> = []
    @Published var totalMonthExpense: [Float] = []

    @Published var expenseFilteredList: [ExpenseViewModel] = []

    @Published var documentsList: [DocumentViewModel] = []

    init() {
        getVehiclesCoreData(filter: nil, storage: { storage in
            self.vehicleList = storage
        })

        getNumbersCoreData(filter: nil, storage: { storage in
            self.numberList = storage

        })

        getDocumentsCoreData(filter: nil, storage: { storage in
            self.documentsList = storage
        })
        //        getCurrentVehicle()
    }

    // MARK: VEHICLE CRUD

    func getVehiclesCoreData(filter: NSPredicate?, storage: @escaping ([VehicleViewModel]) -> Void) {
        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
        let vehicle: [Vehicle]

        let sort = NSSortDescriptor(keyPath: \Vehicle.objectID, ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = filter

        do {
            vehicle = try manager.context.fetch(request)
            DispatchQueue.main.async {
                storage(vehicle.map(VehicleViewModel.init))
            }

        } catch {
            print("🚓 Error fetching vehicles: \(error.localizedDescription)")
        }
    }

    func setAllCurrentToFalse() {
        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
        let vehicle: [Vehicle]
        let filter = NSPredicate(format: "current == %@", "1") // trovo tutti i veicoli che sono a true
        request.predicate = filter
        do {
            vehicle = try manager.context.fetch(request)
            vehicle.first?.current = 0
        } catch {
            print("🚓 Error fetching vehicles: \(error.localizedDescription)")
        }
        save()
    }

    func getCurrentVehicle() {
        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
        let vehicle: [Vehicle]

        let filter = NSPredicate(format: "current == %@", "1")
        request.predicate = filter

        do {
            vehicle = try manager.context.fetch(request)
            DispatchQueue.main.async {
                self.currentVehicle = vehicle.map(VehicleViewModel.init)
                let filterCurrentExpense = NSPredicate(format: "vehicle = %@", (self.currentVehicle.first?.vehicleID)!)
                self.getExpensesCoreData(filter: filterCurrentExpense, storage: { storage in
                    self.expenseList = storage
                    self.getTotalExpense(expenses: storage)
                })
            }
            print("CURRENT VEHICLE LIST ", vehicleList)

        } catch {
            print("🚓 Error fetching current vehicle: \(error.localizedDescription)")
        }
    }

    func addVehicle(vehicle: VehicleState) {
        let newVehicle = Vehicle(context: manager.context)
        newVehicle.name = vehicle.name
        newVehicle.brand = vehicle.brand
        newVehicle.model = vehicle.model
        newVehicle.odometer = vehicle.odometer
        newVehicle.plate = vehicle.plate
        newVehicle.current = vehicle.current
        newVehicle.fuelTypeOne = vehicle.fuelTypeOne
        newVehicle.fuelTypeTwo = vehicle.fuelTypeTwo ?? 0
        print("🚓🚓🚓 ", newVehicle)
        vehicleList.append(VehicleViewModel(vehicle: newVehicle)) // Add the new vehicle to the list
        save()
    }

    func removeAllVehicles() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Vehicle")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        manager.removeAllItems(deleteRequest: deleteRequest)
        save()
        vehicleList.removeAll()
    }

    func deleteVehicleCoreData(vehicle: VehicleViewModel) {
        let vehicle = manager.getEntityBy(id: vehicle.vehicleID) as? Vehicle
        if let vehicle {
            manager.delete(entity: vehicle)
        }
    }

    func deleteVehicle(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let vehicle = vehicleList[index]
            vehicleList.remove(at: index)
            deleteVehicleCoreData(vehicle: vehicle)
        }
    }

    // MARK: VEHICLE UPDATE

    func updateVehicle(_ vs: VehicleState) throws {
        guard let vehicleID = vs.vehicleID else {
            return print("Vehicle ID not found during update")
        }

        guard let vehicle = manager.getEntityBy(id: vehicleID) as? Vehicle else {
            return print("Vehicle not found during update")
        }

        vehicle.name = vs.name
        vehicle.brand = vs.brand
        vehicle.model = vs.model
        vehicle.current = vs.current
        vehicle.odometer = vs.odometer
        vehicle.plate = vs.plate
        vehicle.fuelTypeOne = vs.fuelTypeOne
        vehicle.fuelTypeTwo = vs.fuelTypeTwo ?? 7
        // etc etc

        // PUBLISHED LIST UPDATE
        for (index, value) in vehicleList.enumerated() {
            if value.vehicleID == vs.vehicleID {
                vehicleList.remove(at: index)
                vehicleList.insert(VehicleViewModel(vehicle: vehicle), at: index)
            }
        }

        save()
        print("VEHICLE UPDATE DONE ", vehicle.odometer)
    }

    func getVehicleById(vehicleId: NSManagedObjectID) throws -> VehicleViewModel {
        guard let vehicle = manager.getEntityBy(id: vehicleId) as? Vehicle else {
            throw VehicleError.VehicleNotFound // DA FIXARE
        }

        let vehicleVM = VehicleViewModel(vehicle: vehicle)
        return vehicleVM
    }

    func getVehicle(vehicleID: NSManagedObjectID) -> Vehicle? {
        let vehicle = manager.getEntityBy(id: vehicleID) as? Vehicle
        return vehicle
    }

    func save() {
        manager.save()
    }

    // MARK: - EXPENSE CRUD

    func getExpenseByID(expenseID: NSManagedObjectID) throws -> ExpenseViewModel {
        guard let expense = manager.getEntityBy(id: expenseID) as? Expense else {
            throw VehicleError.VehicleNotFound // DA FIXARE
        }

        let expenseVM = ExpenseViewModel(expense: expense)
        return expenseVM
    }

    func addExpense(expense: ExpenseState) {
        let newExpense = Expense(context: manager.context)
        var newOdometer: Float = 0.0
        newExpense.vehicle = getVehicle(vehicleID: currentVehicle.first!.vehicleID)
        newExpense.note = expense.note
        newExpense.price = expense.price
        newExpense.odometer = expense.odometer
        newExpense.category = expense.category ?? 0
        newExpense.date = expense.date
        newExpense.fuelType = expense.fuelType ?? 0
        newExpense.liters = expense.liters ?? 0.0
        newExpense.priceLiter = expense.priceLiter ?? 1.0
        newOdometer = expense.odometer - (newExpense.vehicle?.odometer ?? 0.0)
        newExpense.vehicle?.odometer += newOdometer
        print(" Expense : \(newExpense)")
        print(" Current Vehicle \(currentVehicle)")
        expenseList.append(ExpenseViewModel(expense: newExpense))
        save()
    }

    // MARK: EXPENSE UPDATE

    func updateExpense(_ es: ExpenseState) throws {
        guard let expenseID = es.expenseID else {
            return print("Expense ID not found during update")
        }

        guard let expense = manager.getEntityBy(id: expenseID) as? Expense else {
            return print("Expense not found during update")
        }

        expense.price = es.price
        expense.odometer = es.price
        expense.date = es.date
        expense.odometer = es.odometer
        expense.priceLiter = es.priceLiter ?? 0.0
        expense.fuelType = es.fuelType ?? 7
        expense.liters = es.liters ?? 0.0
        expense.category = es.category ?? 8
        expense.note = es.note
        expense.vehicle?.odometer = es.odometer

        // PUBLISHED LIST UPDATE
        for (index, value) in expenseList.enumerated() {
            if value.expenseID == es.expenseID {
                expenseList.remove(at: index)
                expenseList.insert(ExpenseViewModel(expense: expense), at: index)
            }
        }

        save()
        print("EXPENSE UPDATE DONE")
    }

    // MARK: EXPENSE DELETE

    //    func removeExpense(indexSet: IndexSet) {
    //        guard let index = indexSet.first else { return }
    //        let entity = expenses[index]
    //        expense
    //    }

    //    func deleteExpense(at indexSet: IndexSet){
    //        indexSet.forEach{ index in
    //            let expense = expenseList[index]
    //            expenseList.remove(at: index)
    //            deleteExpenseCoreData(expense: expense)
    //        }
    //    }

    //    func deleteExpenseCoreData(expense : ExpenseViewModel) {
    //        let expense = manager.getExpenseById(id: expense.expenseID)
    //        if let expense = expense {
    //            manager.deleteExpense(expense)
    //        }
    //        save()
    //    }

    func deleteExpense(expenseS: ExpenseState) {
        guard let expenseID = expenseS.expenseID else {
            return print("Expense ID not found during update")
        }
        if let expense = manager.getEntityBy(id: expenseID) as? Expense {
            manager.delete(entity: expense)
        }
    }

    func removeAllExpenses() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Expense")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        manager.removeAllItems(deleteRequest: deleteRequest)
    }

    func getExpensesCoreData(filter: NSPredicate?, storage: @escaping ([ExpenseViewModel]) -> Void) {
        let request = NSFetchRequest<Expense>(entityName: "Expense")
        let expense: [Expense]

        let sort = NSSortDescriptor(keyPath: \Expense.objectID, ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = filter

        do {
            expense = try manager.context.fetch(request)
            DispatchQueue.main.async {
                storage(expense.map(ExpenseViewModel.init))
            }

        } catch {
            print("💰 Error fetching expenses: \(error.localizedDescription)")
        }
    }

    // MARK: - REMINDERS CRUD

    func addReminder(reminder: ReminderState) {
        let newReminder = Reminder(context: manager.context)
        print("reminderID", reminder.reminderID)
        newReminder.title = reminder.title
        newReminder.note = reminder.note
        newReminder.distance = reminder.distance
        newReminder.recurrence = reminder.recurrence ?? 0
        newReminder.category = reminder.category ?? 0
        newReminder.based = reminder.based ?? 0
        newReminder.date = reminder.date

        print(" Reminder : \(newReminder)")
        reminderList.append(ReminderViewModel(reminder: newReminder))
        save()
    }

    func getRemindersCoreData(filter: NSPredicate?, storage: @escaping ([ReminderViewModel]) -> Void) {
        let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        let reminder: [Reminder]

        let sort = NSSortDescriptor(keyPath: \Reminder.objectID, ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = filter

        do {
            reminder = try manager.context.fetch(request)
            DispatchQueue.main.async {
                storage(reminder.map(ReminderViewModel.init))
            }

        } catch {
            print("🛎 Error fetching reminders: \(error.localizedDescription)")
        }
    }

    func updateReminder(_ rs: ReminderState) throws {
        guard let reminderID = rs.reminderID else {
            return print("Reminder ID not found during update")
        }

        guard let reminder = manager.getEntityBy(id: reminderID) as? Reminder else {
            return print("Reminder not found during update")
        }

        reminder.note = rs.note
        reminder.date = rs.date
        reminder.title = rs.title
        reminder.category = rs.category ?? 1

        for (index, value) in reminderList.enumerated() {
            if value.reminderID == rs.reminderID {
                reminderList.remove(at: index)
            }
        }
        save()
        print("Reminder update done: ", reminder)
    }

    func deleteReminder(reminderS: ReminderState) {
        guard let reminderID = reminderS.reminderID else {
            return print("NumberID not found during update")
        }

        let reminder = manager.getEntityBy(id: reminderID) as? Reminder
        if let reminder {
            manager.delete(entity: reminder)
        }
        save()
    }

    func removeExpiredReminders() {
        let filterExpiredReminders = NSPredicate(format: "date <= %@", NSDate())
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Reminder")
        fetchRequest.predicate = filterExpiredReminders
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        manager.removeAllItems(deleteRequest: deleteRequest)
        expiredReminders.removeAll()
    }

    // MARK: - IMPORTANT NUMBERS CRUD

    func getNumbersCoreData(filter: NSPredicate?, storage: @escaping ([NumberViewModel]) -> Void) {
        let request = NSFetchRequest<Number>(entityName: "Number")
        let number: [Number]

        let sort = NSSortDescriptor(keyPath: \Number.objectID, ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = filter

        do {
            number = try manager.context.fetch(request)
            DispatchQueue.main.async {
                storage(number.map(NumberViewModel.init))
            }

        } catch {
            print("🔢 Error fetching numbers: \(error.localizedDescription)")
        }
    }

    func addNumber(number: NumberState) {
        let newNumber = Number(context: manager.context)
        newNumber.vehicle = getVehicle(vehicleID: currentVehicle.first!.vehicleID)
        newNumber.telephone = number.telephone
        newNumber.title = number.title

        print(" Number : \(newNumber)")
        print(" Current Vehicle \(currentVehicle)")
        numberList.append(NumberViewModel(number: newNumber))
        save()
    }

    func updateNumber(_ ns: NumberState) throws {
        guard let numberID = ns.numberID else {
            return print("Expense ID not found during update")
        }

        guard let number = manager.getEntityBy(id: numberID) as? Number else {
            return print("Expense not found during update")
        }

        number.title = ns.title
        number.telephone = ns.telephone

        // PUBLISHED LIST UPDATE
        for (index, value) in numberList.enumerated() {
            if value.numberID == ns.numberID {
                numberList.remove(at: index)
                numberList.insert(NumberViewModel(number: number), at: index)
            }
        }
        save()
        print("Numbers update done")
    }

    func deleteNumber(numberS: NumberState) {
        guard let numberID = numberS.numberID else {
            return print("NumberID not found during update")
        }

        let number = manager.getEntityBy(id: numberID) as? Number
        if let number {
            manager.delete(entity: number)
        }

        save()
    }

    // MARK: - DOCUMENTS CRUD

    func getDocumentsCoreData(filter: NSPredicate?, storage: @escaping ([DocumentViewModel]) -> Void) {
        let request = NSFetchRequest<Document>(entityName: "Document")
        let document: [Document]

        let sort = NSSortDescriptor(keyPath: \Document.objectID, ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = filter

        do {
            document = try manager.context.fetch(request)
            DispatchQueue.main.async {
                storage(document.map(DocumentViewModel.init))
            }

        } catch {
            print("🔢 Error fetching documents: \(error.localizedDescription)")
        }
    }

    func addDocument(documentS: DocumentState, url: URL) {
        let newDocument = Document(context: manager.context)
        newDocument.title = documentS.title
        //        newDocument.url = documentS.url

        do {
            // Start accessing a security-scoped resource.
            guard url.startAccessingSecurityScopedResource() else {
                // Handle the failure here.
                return
            }

            defer { url.stopAccessingSecurityScopedResource() }

            let bookmarkData = try url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)

            newDocument.bookmark = bookmarkData
        } catch {
            // Handle the error here.
            print("Error creating the bookmark")
        }

        print("Document: \(newDocument)")
        documentsList.append(DocumentViewModel(document: newDocument))
        save()
    }

    func removeAllDocuments() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Document")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        manager.removeAllItems(deleteRequest: deleteRequest)
        save()
        documentsList.removeAll()
    }

    // MARK: - OTHER FUNCS

    func getTotalExpense(expenses: [ExpenseViewModel]) {
        //        print("expense list: \(expenses)")
        totalVehicleCost = 0.0
        for expense in expenses {
            totalVehicleCost += expense.price
        }
        print("sum cost : \(totalVehicleCost)")
        totalExpense = totalVehicleCost
    }

    func getMonths(expenses _: [ExpenseViewModel]) {
        var date = ""
        for expenseList in expenseList {
            date = expenseList.date.toString(dateFormat: "MMMM")
            monthsAmount.insert(date)
        }
    }

    func getMonthsExpense(expenses: [ExpenseViewModel], month: String) -> Float {
        var totalExpense: Float = 0.0
        for expense in expenses {
            if expense.date.toString(dateFormat: "MMMM") == month {
                totalExpense += expense.price
            }
        }
        return totalExpense
    }

    func addNewExpensePriceToTotal(expense: ExpenseState) {
        totalExpense += expense.price
        print("Add new expense")
    }
}

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
