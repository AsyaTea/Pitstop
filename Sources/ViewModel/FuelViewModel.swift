//
//  FuelViewModel.swift
//  Hurricane
//
//  Created by Asya Tealdi on 18/05/22.
//

import Foundation

enum FuelType: String, Codable, Identifiable {
    case diesel
    case gasoline
    case propane
    case methane
    case ethanol
    case hydrogen
    case electric
    case none

    var id: Self { self }
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
