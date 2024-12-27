//
//  FuelViewModel.swift
//  Hurricane
//
//  Created by Asya Tealdi on 18/05/22.
//

import Foundation

enum FuelType: Int, Codable {
    case diesel = 0
    case gasoline = 1
    case propane = 2
    case methane = 3
    case ethanol = 4
    case hydrogen = 5
    case electric = 6
    case none = 7
}

extension FuelType: CaseIterable {
    var label: String {
        switch self {
        case .diesel:
            NSLocalizedString("Diesel", comment: "")
        case .gasoline:
            NSLocalizedString("Gasoline", comment: "")
        case .propane:
            NSLocalizedString("LPG (Propane)", comment: "")
        case .methane:
            NSLocalizedString("CNG (Methane)", comment: "")
        case .ethanol:
            NSLocalizedString("Ethanol", comment: "")
        case .hydrogen:
            NSLocalizedString("Hydrogen", comment: "")
        case .electric:
            NSLocalizedString("Electric", comment: "")
        case .none:
            NSLocalizedString("None", comment: "")
        }
    }
}

class FuelViewModel: ObservableObject {
    @Published var defaultSelectedFuel: Int16 = 1
    @Published var secondarySelectedFuel: Int16 = 7

    var defaultFuelType: FuelType {
        get { FuelType(rawValue: Int(defaultSelectedFuel)) ?? .gasoline }
        set { defaultSelectedFuel = Int16(newValue.rawValue) }
    }

    var secondaryFuelType: FuelType {
        get { FuelType(rawValue: Int(secondarySelectedFuel)) ?? .none }
        set { secondarySelectedFuel = Int16(newValue.rawValue) }
    }

    func resetSelectedFuel() {
        defaultSelectedFuel = 1
        secondarySelectedFuel = 7
    }
}
