//
//  CategoryViewModel.swift
//  Hurricane
//
//  Created by Asya Tealdi on 15/05/22.
//

import Foundation
import SwiftUI

struct Category: Hashable {
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
    
     @Published var categories = [Category(name: "Fuel", color: Palette.colorYellow, icon: "fuelType", totalCosts: 20.0),
                       Category(name: "Mainteinance", color: Palette.colorGreen, icon: "maintanance", totalCosts: 20.0),
                       Category(name: "Insurance", color: Palette.colorOrange, icon: "insurance", totalCosts: 20.0),
                       Category(name: "Tolls", color: Palette.colorOrange, icon: "Tolls", totalCosts: 20.0),
                       Category(name: "Fines", color: Palette.colorOrange, icon: "fines", totalCosts: 20.0),
                       Category(name: "Parking", color: Palette.colorViolet, icon: "parking", totalCosts: 20.0),
                       Category(name: "Other", color: Palette.colorViolet, icon: "other", totalCosts: 20.0),
    ]
    
    @Published var currentPickerTab : String = "Overview"
    
    //Function to calculate total cost of a category
    func totalCategoryCost(category: Category) -> Double {
        
        return 0.0
    }
    
    
}


/*

 
 ARRAYEXPFUEL = FETCHFUEL
 VAR FUELTOTAL
 FOR ARRAYEXPFUEL { VALUE IN
    FUELTOTAL += VALUE
 }
 

 */
