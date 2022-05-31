//
//  CategoryViewModel.swift
//  Hurricane
//
//  Created by Asya Tealdi on 15/05/22.
//

import Foundation
import SwiftUI

enum Category: Int{
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
            return "tolls"
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
    var totalCosts: Double
}

enum CategoryEnum {
    case mainteinance
    case fuel
    case insurance
}


class CategoryViewModel: ObservableObject {
    
     @Published var categories = [Category2(name: "Fuel", color: Palette.colorYellow, icon: "fuelType", totalCosts: 20.0),
                       Category2(name: "Mainteinance", color: Palette.colorGreen, icon: "maintanance", totalCosts: 20.0),
                       Category2(name: "Insurance", color: Palette.colorOrange, icon: "insurance", totalCosts: 20.0),
                       Category2(name: "Tolls", color: Palette.colorOrange, icon: "Tolls", totalCosts: 20.0),
                       Category2(name: "Fines", color: Palette.colorOrange, icon: "fines", totalCosts: 20.0),
                       Category2(name: "Parking", color: Palette.colorViolet, icon: "parking", totalCosts: 20.0),
                       Category2(name: "Other", color: Palette.colorViolet, icon: "other", totalCosts: 20.0)
    ]
    
    @Published var currentPickerTab : String = "Overview"
    
    @Published var arrayCat : [Category] = []
    
    @Published var selectedCategory : Int16 = Int16(Category.fuel.rawValue)
    //Computed properties, pass expenseList through view and call functions
    @Published var fuelTotal: Float = 0.0
    @Published var mainteinanceTotal: Float = 0.0
    @Published var insuranceTotal: Float = 0.0
    @Published var tollsTotal: Float = 0.0
    @Published var finesTotal: Float = 0.0
    @Published var parkingTotal: Float = 0.0
    @Published var otherTotal: Float = 0.0
    
    @Published var categoryList = [ExpenseViewModel]()
    
    @Published var selectedTimeFrame = "All time"
    let timeFrames = ["Per month", "Per 3 months", "Per year" , "All time"]

    

//    init() {
//        self.fuelTotal : Float {
//            getExpensesCategoryList(expensesList: categoryList, category: 0)
//            return totalCategoryCost(categoryList: categoryList)
//        }
//    }
    
    var defaultCategory : Category {
        get {return Category.init(rawValue: Int(selectedCategory)) ?? .other}
        set {selectedCategory = Int16(newValue.rawValue)}
    }
    
    //Function to calculate total cost of a category
    func totalCategoryCost(categoryList: [ExpenseViewModel]) -> Float {
        let fetchedCost = categoryList.map ({ (ExpenseViewModel) -> Float in
            return ExpenseViewModel.price
        })
        print("fetched cost :\(fetchedCost)")
        let totalCost = fetchedCost.reduce(0, +)
        return totalCost
    }
    
//    Takes current expense list and filters through the given category
    func getExpensesCategoryList(expensesList: [ExpenseViewModel], category: Int16) -> [ExpenseViewModel] {
        var categoryList : [ExpenseViewModel]
        categoryList = expensesList.filter({ expense in
            return expense.category == category
        })
        return categoryList
    }
    
    //MARK: Fuel, remember to insert a time frame property to pass

    //Refuel x month, from fuelExpenseList filter those who are in the time frame -> perform count
    
    func getRefuel() {
        
    }
    
    //Average days/refuel, map through fuelExpenseList and return days between 2 fuel expenses in a new array -> calculate avg value
    
    func getAverageDaysRefuel() {
        
    }
    
    //Average price, map through fuel list and return prices in a new array -> calculate avg value
    
    func getAveragePrice() {
        
    }
    
    //MARK: Odometer, remember to insert a time frame property
    
    //Average, take odometer and divide it by the given time -> calculate avg
    
    func getAverageOdometer() {
        
    }
    
    //Time total, take odomenter of now and the last one within time frame and subtract -> value displayed
    
    func getTimeTotal() {
        
    }
    
    //Estimated km/year takes odometer data from time frame, makes an average -> multiply for 12/ 4 / 1 based on time frame
    
    func getEstimatedOdometerPerYear() {
        
    }
    
}



