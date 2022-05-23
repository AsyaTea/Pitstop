//
//  CategoryViewModel.swift
//  Hurricane
//
//  Created by Asya Tealdi on 15/05/22.
//

import Foundation
import SwiftUI

enum Category: Int{
    case fuel = 0
    case maintenance = 1
    case insurance = 2
    case roadTax = 3
    case tolls = 4
    case fines = 5
    case parking = 6
    case other = 7
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
    
    //Function to calculate total cost of a category
    func totalCategoryCost(category: Category2) -> Double {
        
        return 0.0
    }
    
    
    @Published var selectedCategory : Int16 = 0
    
    var defaultCategory : Category {
        get {return Category.init(rawValue: Int(selectedCategory)) ?? .other}
        set {selectedCategory = Int16(newValue.rawValue)}
    }
    
    
}


/*

 
 ARRAYEXPFUEL = FETCHFUEL
 VAR FUELTOTAL
 FOR ARRAYEXPFUEL { VALUE IN
    FUELTOTAL += VALUE
 }
 

 */
