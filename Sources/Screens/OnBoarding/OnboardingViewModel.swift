//
//  OnboardingViewModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 11/05/22.
//

import Foundation
import SwiftUI
import UserNotifications

class OnboardingViewModel: ObservableObject {
    @Published var vehicle: VehicleState = .init()

//    let fuelCategories = ["Gasoline","Diesel", "Electric","LPG (Propane)","CNG (Methane)","Ethanol","Hydrogen"]
//    @Published var selectedFuel = "Fuel Type"

    @Published var destination: Pages = .page1

    var isDisabled: Bool {
        vehicle.name.isEmpty || vehicle.brand.isEmpty || vehicle.model.isEmpty || vehicle.fuelTypeOne == FuelType.none.rawValue
//        return false // debugging
    }

    @Published var skipNotification = false /// Skip notiification page when adding another car
    @Published var removeBack = false /// Remove back button when adding another car

    @Published var addNewVehicle = false
}

enum Pages {
    case page1
    case page2
    case page3(Binding<Vehicle2>)
    case page4
    case page5
}
