//
//  FuelViewModel.swift
//  Hurricane
//
//  Created by Asya Tealdi on 18/05/22.
//

import Foundation

enum FuelType: Int {
    case diesel = 0
    case gasoline = 1
    case propane = 2
    case methane = 3
    case ethanol = 4
    case hydrogen = 5
    case electric = 6
}

extension FuelType : CaseIterable{
    var label : String {
        switch self {
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
}




class FuelViewModel: ObservableObject {
    
    @Published var selectedFuel : Int16 = 1
    
    var currentFuelType : FuelType {
        get {return FuelType.init(rawValue: Int(selectedFuel)) ?? .gasoline}
        set {selectedFuel = Int16(newValue.rawValue)}
    }
    

    
    init() {
    }
    
    
//    func getFuelType(fuel: FuelType) -> String {
//
//        switch fuel {
//        case .diesel:
//            return "Diesel"
//        case .gasoline:
//            return "Gasoline"
//        case .propane:
//            return "LPG (Propane)"
//        case .methane:
//            return "CNG (Methane)"
//        case .ethanol:
//            return "Ethanol"
//        case .hydrogen:
//            return "Hydrogen"
//        case .electric:
//            return "Electric"
//        
//
//        }
//    }
}


