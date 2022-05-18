//
//  FuelViewModel.swift
//  Hurricane
//
//  Created by Asya Tealdi on 18/05/22.
//

import Foundation

enum FuelType: Int32, CaseIterable {
    case diesel = 0
    case gasoline = 1
    case propane = 2
    case methane = 3
    case ethanol = 4
    case hydrogen = 5
    case electric = 6
   
}

class FuelViewModel: ObservableObject {
    
    @Published var selectedFuel = FuelType.diesel
    
    var currentFuelType : String {
        get {
            return getFuelType(fuel: selectedFuel)
        }
    }
    
    init() {
    }
    
    func getFuelString(value: Int32) -> String {
        var string = "Default"
        if (value == 0 ) { string = "Diesel" }
        if (value == 0 ) { string = "Diesel"}
        return string
    }
    
    func getFuelType(fuel: FuelType) -> String {
        
        switch fuel {
        case .diesel:
            return "Diesel"
        case .gasoline:
            return "Gasoline"
        case .propane:
            return "LPG (Propane)"
        case .methane:
            return "CNG (Methane)"
        case .ethanol:
            return "Ethanol"
        case .hydrogen:
            return "Hydrogen"
        case .electric:
            return "Electric"
      
        }
    
    }
    
//    func getFuelType(string: String) -> FuelType {
//
//        switch string {
//        case "Diesel":
//            return FuelType.diesel
//        }
//
//
//    }
    
    
    
}


