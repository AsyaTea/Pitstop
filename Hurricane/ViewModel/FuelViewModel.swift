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
    case none = 7
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
        case .none:
            return "None"
        }
    }
}


class FuelViewModel: ObservableObject {
    
    @Published var defaultSelectedFuel : Int16 = 1
    @Published var secondarySelectedFuel : Int16 = 7
    
    var defaultFuelType : FuelType {
        get {return FuelType.init(rawValue: Int(defaultSelectedFuel)) ?? .gasoline}
        set {defaultSelectedFuel = Int16(newValue.rawValue)}
    }
    
    var secondaryFuelType : FuelType {
        get {return FuelType.init(rawValue: Int(secondarySelectedFuel)) ?? .none}
        set {secondarySelectedFuel = Int16(newValue.rawValue)}
    }
    
    func resetSelectedFuel() {
        defaultSelectedFuel = 1
        secondarySelectedFuel = 7
    }
    
}


