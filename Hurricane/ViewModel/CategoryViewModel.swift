//
//  CategoryViewModel.swift
//  Hurricane
//
//  Created by Asya Tealdi on 15/05/22.
//

import Foundation
import SwiftUI
import CoreData


class CategoryViewModel: ObservableObject {
    
    @Published var categories = [Category2]()
    
    @Published var currentPickerTab : String = String(localized: "Overview")
    
    @Published var arrayCat : [Category] = []
    
    @Published var selectedCategory : Int16 = Int16(Category.fuel.rawValue)
   
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
    @Published var filter : NSPredicate?
    @Published var vehicleList : [VehicleViewModel] = []
    @Published var currentVehicle : [VehicleViewModel] = []
    @Published var expenseList : [ExpenseViewModel] = []
    @Published var totalExpense : Float = 0.0
    
    @Published var refuelsPerTime: Int = 0
    @Published var avgDaysRefuel: Int = 0
    @Published var avgPrice : Int = 0
    
    @Published var currentOdometer: Double = 0
    @Published var odometerTimeTotal: Double = 0
    var avgOdometer: Float = 0
    var odometerTotal : Float = 0
    var estimatedOdometerPerYear : Float = 0
    var literDiff : Float = 0
    @Published var fuelEff : Float = 0
    
    @Published var taxesCost: Float = 0
    @Published var otherCost: Float = 0
    
    
    var fuelPercentage : Float = 0
    var taxesPercentage: Float = 0
    var maintainancePercentage : Float = 0
    var otherPercentage : Float = 0
    
    var fuelGraphData : [CGFloat] = []
    var odometerGraphData : [CGFloat] = []
    
    
    @Published var selectedTimeFrame = String(localized: "Per month")
    let timeFrames = [String(localized: "Per month" ), String(localized:"Per 3 months"), String(localized:"Per year") , String(localized:"All time")]
    
    
    
    init()  {
        print("categoryVM recreating")
        getCurrentVehicle()
    }
    
    var defaultCategory : Category {
        get {return Category.init(rawValue: Int(selectedCategory)) ?? .other}
        set {selectedCategory = Int16(newValue.rawValue)}
    }
    
    func setSelectedTimeFrame(timeFrame: String) {
        self.selectedTimeFrame = timeFrame
        print("selected time frame \(self.selectedTimeFrame)")
    }
    
    
    //Function to calculate total cost of a category
    static func totalCategoryCost(categoryList: [ExpenseViewModel]) -> Float {
        let fetchedCost = categoryList.map ({ (ExpenseViewModel) -> Float in
            return ExpenseViewModel.price
        })
        //        print("fetched cost :\(fetchedCost)")
        let totalCost = fetchedCost.reduce(0, +)
        return totalCost
    }
    
    //    Takes current expense list and filters through the given category
    static func getExpensesCategoryList(expensesList: [ExpenseViewModel], category: Int16) -> [ExpenseViewModel] {
        var categoryList : [ExpenseViewModel]
        categoryList = expensesList.filter({ expense in
            return expense.category == category
        })
        return categoryList
    }
    
    //Function to add or subtract month from current date.
    func addOrSubtractMonths(month: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: month, to: Date())!
    }
    
    func calculateTimeFrame(timeFrame: String) -> Int {
        var monthSub : Int {
            if timeFrame == String(localized:"Per month") {
                return -1
            } else if timeFrame == String(localized:"Per 3 months") {
                return -3
            } else if timeFrame == String(localized:"Per year") {
                return -12
            } else {
                return 0
            }
        }
        return monthSub
    }
    
    func calculateDays(timeFrame: String) -> Int {
        var Days : Int {
            if timeFrame == String(localized:"Per month") {
                return 30
            } else if timeFrame == String(localized:"Per 3 months") {
                return 90
            } else if timeFrame == String(localized:"Per year") {
                return 365
            } else {
                return 0
            }
        }
        return Days
    }
    
    
    //MARK: Fuel, remember to insert a time frame property to pass
    
    //Fuel Efficiency, every 100 km
    
    func getFuelEfficiency(timeFrame: String, fuelList: [ExpenseViewModel]) {
        let time = calculateTimeFrame(timeFrame: timeFrame)
        let timeSubMonth = addOrSubtractMonths(month: time)
        
        var expenseListTime = expenseList.filter { expense in
            expense.date > timeSubMonth
        }
        expenseListTime.sort { expenseOne, expenseTwo in
            return expenseOne.date > expenseTwo.date
        }
        let literArray = expenseListTime.map { expense in
            return expense.liters
        }
        print("lierarray \(literArray)")
        let literSum = literArray.reduce(0, +)
        self.literDiff = literSum - Float(expenseListTime.last?.liters ?? 0.0)
        print("liter sum \(literSum)")
        let q = self.odometerTotal / 100
        print("q is \(q)")
        if q != 0.0 {
            self.fuelEff = literSum / q
        } else {
            self.fuelEff = q
        }
        print("fuel efficiency \(self.fuelEff)")
        
        //self.odometerTotal
    }
    
    //Refuel x month, from fuelExpenseList filter those who are in the time frame -> perform count
    
    func getRefuel(timeFrame: String, fuelList: [ExpenseViewModel])  {
        print("current time frame is \(self.selectedTimeFrame)")
        print("time frame is \(timeFrame)")
        let monthSub = calculateTimeFrame(timeFrame: timeFrame)
        if monthSub != 0 {
            let monthSubtractedDate = addOrSubtractMonths(month: monthSub)
            
            let monthFuels = fuelList.filter { refuel in
                return refuel.date > monthSubtractedDate
            }
            
            self.refuelsPerTime = monthFuels.count
            print(self.refuelsPerTime)
        } else {
            self.refuelsPerTime = fuelList.count
        }
    }
    
    //Average days/refuel, map through fuelExpenseList and return days between 2 fuel expenses in a new array -> calculate avg value
    
    func getAverageDaysRefuel(timeFrame: String, fuelList: [ExpenseViewModel]) {
        let dateArray = fuelList.map { (ExpenseViewModel) -> Date in
            return ExpenseViewModel.date
        }
        
        var daysDiff = [TimeInterval]()
        for (index,date) in dateArray.enumerated() {
            if date != dateArray.last {
                daysDiff.append(Date.timeDifference(lhs: date, rhs: dateArray[index+1]))
            }
        }
        let daysDiffInt = daysDiff.map { sec in
            //absolute abs floor sec / 86400 // dividi la differenza per giorni
            return Int(floor(abs(sec/86400)))
        }
        print("date array\(daysDiffInt)")
        
        
        self.avgDaysRefuel = (daysDiffInt.reduce(0, +))/daysDiffInt.count
        print("avg days : \(self.avgDaysRefuel)")
        
    }
    
    //Average price x liter, map through fuel list and return prices in a new array -> calculate avg value ------ DA TESTARE
    
    func getAveragePrice(timeFrame: String, fuelList: [ExpenseViewModel]) {
        let priceArray = fuelList.map { expense in
            return expense.price
        }
        let literArray = fuelList.map { expense in
            return expense.liters
        }
        print("price array : \(priceArray)")
        if literArray.reduce(0, +) != 0 {
            self.avgPrice = Int(priceArray.reduce(0, +))/Int(literArray.reduce(0, +))
        }
        
    }
    
    
    
    //MARK: Odometer, remember to insert a time frame property
    
    //Average, take odometer and the last one within time frame, sub and divide it by the given time -> calculate avg
    
    func getAverageOdometer(expenseList: [ExpenseViewModel], timeFrame: String) {
        let monthSub = calculateTimeFrame(timeFrame: timeFrame)
        let monthSubtractedDate = addOrSubtractMonths(month: monthSub)
        
        var expenseListTime = expenseList.filter { expense in
            expense.date > monthSubtractedDate
        }
        expenseListTime.sort { expenseOne, expenseTwo in
            return expenseOne.date > expenseTwo.date
        }
        self.odometerTotal = Float(expenseListTime.first?.odometer ?? 0.0) - Float(expenseListTime.last?.odometer ?? 0.0)
        print("odometer difference : \(odometerTotal)")
        
        let days = calculateDays(timeFrame: timeFrame)
        self.avgOdometer = odometerTotal / Float(days)
        
    
    }
    
    //Estimated km/year takes odometer data from time frame, makes an average -> multiply for 12/ 4 / 1 based on time frame
    
    func getEstimatedOdometerPerYear(timeFrame: String) {
        //        let days = calculateDays(timeFrame: timeFrame)
        self.estimatedOdometerPerYear = self.avgOdometer * Float(365)
    }
    
    
    
    func totalCostPercentage(totalCost: Float, expenseList: [ExpenseViewModel]) {
        
        
        self.fuelPercentage = (self.fuelTotal / totalCost) * 100
        self.taxesPercentage = ((self.insuranceTotal + self.roadTaxTotal + self.finesTotal + self.tollsTotal) / totalCost ) * 100
        self.maintainancePercentage = (self.maintenanceTotal / totalCost) * 100
        self.otherPercentage = ((self.otherTotal + self.parkingTotal) / totalCost) * 100
        
    }
    
    func getTotalExpense(expenses: [ExpenseViewModel]) {
        self.totalExpense = 0.0
        for expense in expenses {
            totalExpense += expense.price
        }
        print("sum cost : \(totalExpense)")
        self.totalExpense = totalExpense
        
    }
    
    func getLitersData(expenses: [ExpenseViewModel]) {
        let litersArray = expenses.map { expense -> Float in
            return expense.liters
        }
        print("liters array: \(litersArray)")
        let liters = litersArray.filter { liter in
            liter > 0
        }
        print("liter are \(liters)")
        
        self.fuelGraphData = liters.map({ liter in
            return CGFloat(liter)
        })
        
    }
    
    func getOdometersData(expenses: [ExpenseViewModel]) {
        let odometerArray = expenses.map { expense in
            return expense.odometer
        }
        let odometers = odometerArray.filter { odometer in
            odometer > 0
        }
        print("odometer array is \(odometerArray)")
        self.odometerGraphData = odometers.map({ odometer in
            return CGFloat(odometer)
        })
    }
    
    
    
    func assignCategories(expenseList: [ExpenseViewModel]) {
        
        self.fuelList = CategoryViewModel.getExpensesCategoryList(expensesList: self.expenseList, category: 8)
        self.maintenanceList = CategoryViewModel.getExpensesCategoryList(expensesList: self.expenseList, category: 1)
        self.insuranceList = CategoryViewModel.getExpensesCategoryList(expensesList: self.expenseList, category: 2)
        self.roadTaxList = CategoryViewModel.getExpensesCategoryList(expensesList: self.expenseList, category: 3)
        self.tollsList = CategoryViewModel.getExpensesCategoryList(expensesList: self.expenseList, category: 4)
        self.finesList = CategoryViewModel.getExpensesCategoryList(expensesList: self.expenseList, category: 5)
        self.parkingList = CategoryViewModel.getExpensesCategoryList(expensesList: self.expenseList, category: 6)
        self.otherList = CategoryViewModel.getExpensesCategoryList(expensesList: self.expenseList, category: 7)
        
        
        self.fuelTotal = CategoryViewModel.totalCategoryCost(categoryList: self.fuelList)
        self.maintenanceTotal = CategoryViewModel.totalCategoryCost(categoryList: self.maintenanceList)
        self.insuranceTotal = CategoryViewModel.totalCategoryCost(categoryList: self.insuranceList)
        self.tollsTotal = CategoryViewModel.totalCategoryCost(categoryList: self.tollsList)
        self.roadTaxTotal = CategoryViewModel.totalCategoryCost(categoryList: self.roadTaxList)
        self.finesTotal = CategoryViewModel.totalCategoryCost(categoryList: self.finesList)
        self.parkingTotal = CategoryViewModel.totalCategoryCost(categoryList: self.parkingList)
        self.otherTotal = CategoryViewModel.totalCategoryCost(categoryList: self.otherList)
        
        
        self.categories = [Category2(name: String(localized: "Fuel"), color: Palette.colorYellow, icon: "fuelType", totalCosts: self.fuelTotal),
                           Category2(name: String(localized: "Maintenance"), color: Palette.colorGreen, icon: "maintenance", totalCosts: self.maintenanceTotal),
                           Category2(name: String(localized: "Insurance"), color: Palette.colorOrange, icon: "insurance", totalCosts: self.insuranceTotal),
                           Category2(name: String(localized: "Road tax"), color: Palette.colorOrange, icon: "roadTax", totalCosts: self.roadTaxTotal),
                           Category2(name: String(localized: "Fines"), color: Palette.colorOrange, icon: "fines", totalCosts: self.finesTotal),
                           Category2(name: String(localized: "Tolls"), color: Palette.colorOrange, icon: "Tolls", totalCosts: self.tollsTotal),
                           Category2(name: String(localized: "Parking"), color: Palette.colorViolet, icon: "parking", totalCosts: self.parkingTotal),
                           Category2(name: String(localized: "Other"), color: Palette.colorViolet, icon: "other", totalCosts: self.otherTotal)
        ]
    }
    
    func retrieveAndUpdate(vehicleID: NSManagedObjectID) {
        self.expenseList = []
        self.avgOdometer = 0
        self.odometerTotal = 0
        self.estimatedOdometerPerYear = 0
        let filterCurrentExpense = NSPredicate(format: "vehicle = %@", (vehicleID))
        self.getExpensesCoreData(filter: filterCurrentExpense, storage:  { storage in
            self.expenseList = storage
            self.assignCategories(expenseList: storage)
            self.getRefuel(timeFrame: self.selectedTimeFrame, fuelList: self.fuelList)
            
            if self.fuelList.count >= 2 {
                self.getAverageOdometer(expenseList: self.expenseList, timeFrame: self.selectedTimeFrame)
                self.getEstimatedOdometerPerYear(timeFrame: self.selectedTimeFrame)
                
                self.getAverageDaysRefuel(timeFrame: self.selectedTimeFrame, fuelList: self.fuelList)
                self.getAveragePrice(timeFrame: self.selectedTimeFrame, fuelList: self.fuelList)
                
            }
            self.getFuelEfficiency(timeFrame: self.selectedTimeFrame, fuelList: self.fuelList)
            self.getTotalExpense(expenses: self.expenseList)
            self.totalCostPercentage(totalCost: self.totalExpense, expenseList: self.expenseList)
            self.getLitersData(expenses: self.expenseList)
            self.getOdometersData(expenses: self.expenseList)
        })
    }
    
    func getCurrentVehicle() {
        let request = NSFetchRequest<Vehicle>(entityName: "Vehicle")
        let vehicle : [Vehicle]
        
        let filter = NSPredicate(format: "current == %@","1")
        request.predicate = filter
        
        do {
            vehicle =  try manager.context.fetch(request)
            DispatchQueue.main.async {
                self.currentVehicle = vehicle.map(VehicleViewModel.init)
                if !self.currentVehicle.isEmpty {
                    self.retrieveAndUpdate(vehicleID: self.currentVehicle.first!.vehicleID)
                }
                
                
            }
            print("CURRENT VEHICLE LIST ",vehicleList)
            
        }catch let error {
            print("🚓 Error fetching current vehicle: \(error.localizedDescription)")
        }
    }
    
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
    
    func getVehicle(vehicleID: NSManagedObjectID) -> Vehicle? {
        let vehicle = manager.getVehicleById(id: vehicleID)
        return vehicle
    }
}

enum Category: Int,Hashable{
    case maintenance = 1
    case insurance = 2
    case roadTax = 3
    case tolls = 4
    case fines = 5
    case parking = 6
    case other = 7
    case fuel = 8
}

extension Category : CaseIterable{
    var label : String {
        switch self {
        case .fuel:
            return NSLocalizedString("Fuel", comment: "")
        case .maintenance:
            return NSLocalizedString("Maintenance", comment: "")
        case .insurance:
            return NSLocalizedString("Insurance", comment: "")
        case .roadTax:
            return NSLocalizedString("Road tax", comment: "")
        case .tolls:
            return NSLocalizedString("Tolls", comment: "")
        case .fines:
            return NSLocalizedString("Fines", comment: "")
        case .parking:
            return NSLocalizedString("Parking", comment: "")
        case .other:
            return NSLocalizedString("Other", comment: "")
        }
    }
    
    var icon : String {
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
            return "Tolls"
        case .fines:
            return "fines"
        case .parking:
            return "parking"
        case .other:
            return "other"
        }
    }
    
    var color : Color {
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
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    
}




