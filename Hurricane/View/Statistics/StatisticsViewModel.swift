//
//  StatisticsViewModel.swift
//  Hurricane
//
//  Created by Asya Tealdi on 23/05/22.
//

import Foundation
import SwiftUI

class StatisticsViewModel : ObservableObject {
    @Published var selectedTimeFrame = String(localized:"All time")
    let timeFrames = [String(localized: "Per month" ), String(localized:"Per 3 months"), String(localized:"Per year") , String(localized:"All time")]
    
    @Published var categoryExpensesList = [ExpenseViewModel]()
    

    
}
//
//struct Category: Hashable {
//    var name: String
//    var color: Color
//    var icon: String
//    var totalCosts: Double
//}
//
//enum CategoryEnum {
//    case maintenance
//    case fuel
//    case insurance
//    case tolls
//    case fines
//    case parking
//    case other
//
//}
//
//class CategoryViewModel: ObservableObject {
//
//     @Published var categories = [Category(name: "Fuel", color: Palette.colorYellow, icon: "fuelType", totalCosts: 20.0),
//                       Category(name: "Maintenance", color: Palette.colorGreen, icon: "maintanance", totalCosts: 20.0),
//                       Category(name: "Insurance", color: Palette.colorOrange, icon: "insurance", totalCosts: 20.0),
//                       Category(name: "Tolls", color: Palette.colorOrange, icon: "Tolls", totalCosts: 20.0),
//                       Category(name: "Fines", color: Palette.colorOrange, icon: "fines", totalCosts: 20.0),
//                       Category(name: "Parking", color: Palette.colorViolet, icon: "parking", totalCosts: 20.0),
//                       Category(name: "Other", color: Palette.colorViolet, icon: "other", totalCosts: 20.0),
//    ]
//
//    @Published var currentPickerTab : String = "Overview"
//
//    //Function to calculate total cost of a category
//    func totalCategoryCost(category: Category) -> Double {
//
//        return 0.0
//    }
//
//
//}
