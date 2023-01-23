//
//  CategoryViewModel.swift
//  Hurricane
//
//  Created by Asya Tealdi on 15/05/22.
//

import CoreData
import Foundation
import SwiftUI

class CategoryViewModel: ObservableObject {
    @Published var categories = [Category2]()

    @Published var currentPickerTab: String = "Overview"

    @Published var arrayCat: [Category] = []

    @Published var selectedCategory: Int16 = .init(Category.fuel.rawValue)
    // Computed properties, pass expenseList through view and call functions
    @Published var fuelTotal: Float = 0.0
    @Published var maintenanceTotal: Float = 0.0
    @Published var insuranceTotal: Float = 0.0
    @Published var tollsTotal: Float = 0.0
    @Published var roadTaxTotal: Float = 0.0
    @Published var finesTotal: Float = 0.0
    @Published var parkingTotal: Float = 0.0
    @Published var otherTotal: Float = 0.0

    @Published var fuelList = [ExpenseViewModel]()
    @Published var maintenanceList = [ExpenseViewModel]()
    @Published var insuranceList = [ExpenseViewModel]()
    @Published var tollsList = [ExpenseViewModel]()
    @Published var roadTaxList = [ExpenseViewModel]()
    @Published var finesList = [ExpenseViewModel]()
    @Published var parkingList = [ExpenseViewModel]()
    @Published var otherList = [ExpenseViewModel]()

    let manager = CoreDataManager.instance
    @Published var filter: NSPredicate?
    @Published var vehicleList: [VehicleViewModel] = [] // Var to store all the fetched vehicle entities
    @Published var currentVehicle: [VehicleViewModel] = []
//    var dataVM : DataViewModel
    @Published var expenseList: [ExpenseViewModel] = []
    @Published var totalExpense: Float = 0.0

    @Published var refuelsPerTime: Int = 0
    @Published var avgDaysRefuel: Int = 0
    @Published var avgPrice: Int = 0

    @Published var currentOdometer: Double = 0
    @Published var odometerTimeTotal: Double = 0

    @Published var selectedTimeFrame = "Per month"
    let timeFrames = ["Per month", "Per 3 months", "Per year", "All time"]

    init() {
//        getCurrentVehicle()
    }

    var defaultCategory: Category {
        get { Category(rawValue: Int(selectedCategory)) ?? .other }
        set { selectedCategory = Int16(newValue.rawValue) }
    }

    func setSelectedTimeFrame(timeFrame: String) {
        selectedTimeFrame = timeFrame
        print("selected time frame \(selectedTimeFrame)")
    }

    // Function to calculate total cost of a category
    static func totalCategoryCost(categoryList: [ExpenseViewModel]) -> Float {
        let fetchedCost = categoryList.map { ExpenseViewModel -> Float in
            ExpenseViewModel.price
        }
//        print("fetched cost :\(fetchedCost)")
        let totalCost = fetchedCost.reduce(0, +)
        return totalCost
    }

//    Takes current expense list and filters through the given category
    static func getExpensesCategoryList(expensesList: [ExpenseViewModel], category: Int16) -> [ExpenseViewModel] {
        var categoryList: [ExpenseViewModel]
        categoryList = expensesList.filter { expense in
            expense.category == category
        }
        return categoryList
    }

    // Function to add or subtract month from current date.
    func addOrSubtractMonths(month: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: month, to: Date())!
    }

    func calculateTimeFrame(timeFrame: String) -> Int {
        var monthSub: Int {
            if timeFrame == "Per month" {
                return -1
            } else if timeFrame == "Per 3 months" {
                return -3
            } else if timeFrame == "Per year" {
                return -12
            } else {
                return 0
            }
        }
        return monthSub
    }

    // MARK: Fuel, remember to insert a time frame property to pass

    // Refuel x month, from fuelExpenseList filter those who are in the time frame -> perform count

    func getRefuel(timeFrame: String, fuelList: [ExpenseViewModel]) {
        print("current time frame is \(selectedTimeFrame)")
        print("time frame is \(timeFrame)")
        let monthSub = calculateTimeFrame(timeFrame: timeFrame)
        if monthSub != 0 {
            let monthSubtractedDate = addOrSubtractMonths(month: monthSub)

            let monthFuels = fuelList.filter { refuel in
                refuel.date > monthSubtractedDate
            }

            refuelsPerTime = monthFuels.count
            print(refuelsPerTime)
        } else {
            refuelsPerTime = fuelList.count
        }
    }

    // Average days/refuel, map through fuelExpenseList and return days between 2 fuel expenses in a new array -> calculate avg value --- TESTARE SE WORKA ALL INIT

    func getAverageDaysRefuel(timeFrame _: String, fuelList: [ExpenseViewModel]) {
        let dateArray = fuelList.map { ExpenseViewModel -> Date in
            ExpenseViewModel.date
        }

        var daysDiff = [TimeInterval]()
        for (index, date) in dateArray.enumerated() {
            if date != dateArray.last {
                daysDiff.append(Date.timeDifference(lhs: date, rhs: dateArray[index + 1]))
            }
        }
        let daysDiffInt = daysDiff.map { sec in
            // absolute abs floor sec / 86400
            Int(floor(abs(sec / 86400)))
        }
        print("date array\(daysDiffInt)")

        avgDaysRefuel = (daysDiffInt.reduce(0, +)) / 1 + daysDiffInt.count
        print("avg days : \(avgDaysRefuel)")
    }

    // Average price, map through fuel list and return prices in a new array -> calculate avg value ------ DA TESTARE

    func getAveragePrice(timeFrame _: String, fuelList: [ExpenseViewModel]) {
        let priceArray = fuelList.map { expense in
            expense.price
        }
        avgPrice = Int(priceArray.reduce(0, +)) / priceArray.count
    }

    // MARK: Odometer, remember to insert a time frame property

    // Average, take odometer and divide it by the given time -> calculate avg

    func getAverageOdometer(odometer _: Double) {
        let lastExpense: ExpenseViewModel
        // prendi l'odometer dell ultima expense
        // prendi odometer della prima expense nel time range
        // sub
        // dividi il risultato x i giorni
    }

    // Time total, take odometer of now and the last one within time frame and subtract -> value displayed

    func getTimeTotal() {
        // implement this in the function up here
    }

    // Estimated km/year takes odometer data from time frame, makes an average -> multiply for 12/ 4 / 1 based on time frame

    func getEstimatedOdometerPerYear() {}

    func assignCategories(expenseList _: [ExpenseViewModel]) {
        fuelList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 8)
        maintenanceList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 1)
        insuranceList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 2)
        roadTaxList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 3)
        tollsList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 4)
        finesList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 5)
        parkingList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 6)
        otherList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 7)

        fuelTotal = CategoryViewModel.totalCategoryCost(categoryList: fuelList)
        maintenanceTotal = CategoryViewModel.totalCategoryCost(categoryList: maintenanceList)
        insuranceTotal = CategoryViewModel.totalCategoryCost(categoryList: insuranceList)
        tollsTotal = CategoryViewModel.totalCategoryCost(categoryList: tollsList)
        roadTaxTotal = CategoryViewModel.totalCategoryCost(categoryList: roadTaxList)
        finesTotal = CategoryViewModel.totalCategoryCost(categoryList: finesList)
        parkingTotal = CategoryViewModel.totalCategoryCost(categoryList: parkingList)
        otherTotal = CategoryViewModel.totalCategoryCost(categoryList: otherList)

        categories = [Category2(name: "Fuel", color: Palette.colorYellow, icon: "fuelType", totalCosts: fuelTotal),
                      Category2(name: "Maintenance", color: Palette.colorGreen, icon: "maintenance", totalCosts: maintenanceTotal),
                      Category2(name: "Insurance", color: Palette.colorOrange, icon: "insurance", totalCosts: insuranceTotal),
                      Category2(name: "Tolls", color: Palette.colorOrange, icon: "Tolls", totalCosts: tollsTotal),
                      Category2(name: "Fines", color: Palette.colorOrange, icon: "fines", totalCosts: finesTotal),
                      Category2(name: "Parking", color: Palette.colorViolet, icon: "parking", totalCosts: parkingTotal),
                      Category2(name: "Road Tax", color: Palette.colorViolet, icon: "other", totalCosts: roadTaxTotal),
                      Category2(name: "Other", color: Palette.colorViolet, icon: "other", totalCosts: otherTotal)]
    }

    func retrieveAndUpdate() {
        expenseList = []
        let filterCurrentExpense = NSPredicate(format: "vehicle = %@", (currentVehicle.first?.vehicleID)!)
        getExpensesCoreData(filter: filterCurrentExpense, storage: { storage in
            self.expenseList = storage
            self.assignCategories(expenseList: storage)
            self.getRefuel(timeFrame: self.selectedTimeFrame, fuelList: self.fuelList)

            if !self.fuelList.isEmpty {
                self.getAverageDaysRefuel(timeFrame: self.selectedTimeFrame, fuelList: self.fuelList)
            }
        })
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
                if !self.currentVehicle.isEmpty {
                    self.retrieveAndUpdate()
                }
            }
            print("CURRENT VEHICLE LIST ", vehicleList)

        } catch {
            print("🚓 Error fetching current vehicle: \(error.localizedDescription)")
        }
    }

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

    func getVehicle(vehicleID: NSManagedObjectID) -> Vehicle? {
        let vehicle = manager.getVehicleById(id: vehicleID)
        return vehicle
    }
}

enum Category: Int, Hashable {
    case maintenance = 1
    case insurance = 2
    case roadTax = 3
    case tolls = 4
    case fines = 5
    case parking = 6
    case other = 7
    case fuel = 8
}

extension Category: CaseIterable {
    var label: String {
        switch self {
        case .fuel:
            return "Fuel"
        case .maintenance:
            return "Maintenance"
        case .insurance:
            return "Insurance"
        case .roadTax:
            return "Road tax"
        case .tolls:
            return "Tolls"
        case .fines:
            return "Fines"
        case .parking:
            return "Parking"
        case .other:
            return "Other"
        }
    }

    var icon: String {
        switch self {
        case .fuel:
            return "fuel"
        case .maintenance:
            return "maintenance"
        case .insurance:
            return "insurance"
        case .roadTax:
            return "roadTax"
        case .tolls:
            return "tolls"
        case .fines:
            return "fines"
        case .parking:
            return "parking"
        case .other:
            return "other"
        }
    }

    var color: Color {
        switch self {
        case .fuel:
            return Palette.colorYellow
        case .maintenance:
            return Palette.colorGreen
        case .insurance:
            return Palette.colorOrange
        case .roadTax:
            return Palette.colorOrange
        case .tolls:
            return Palette.colorOrange
        case .fines:
            return Palette.colorOrange
        case .parking:
            return Palette.colorViolet
        case .other:
            return Palette.colorViolet
        }
    }
}

struct Category2: Hashable {
    var name: String
    var color: Color
    var icon: String
    var totalCosts: Float
}

enum CategoryEnum {
    case maintenance
    case fuel
    case insurance
}

extension Date {
    static func timeDifference(lhs: Date, rhs: Date) -> TimeInterval {
        lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

    static func - (recent: Date, previous: Date) -> (month: Int?, day: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month

        return (month: month, day: day)
    }
}
