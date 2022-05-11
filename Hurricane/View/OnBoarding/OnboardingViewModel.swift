//
//  OnboardingViewModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 11/05/22.
//

import Foundation
import UserNotifications

class OnboardingViewModel : ObservableObject {
    
    @Published var vehicle : VehicleModel = VehicleModel()
    
    let fuelCategories = ["Gasoline","Diesel", "Electric","LPG (Propane)","CNG (Methane)","Ethanol","Hydrogen"]
    @Published var selectedFuel = "Fuel Type"
    
    var isDisabled : Bool {
        //        return carName.isEmpty || brand.isEmpty || model.isEmpty || selectedFuel == "Fuel Type"
        return false
    }
    
    func resetFields() {
        vehicle.name = ""
        vehicle.brand = ""
        vehicle.model = ""
        selectedFuel = "Fuel Type"
    }
    
    func requestAuthNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
}



