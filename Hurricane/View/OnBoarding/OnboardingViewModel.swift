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
    
    @Published var destination : Pages = .page1
    
    var isDisabled : Bool {
//        return vehicle.name?.isEmpty ?? false || vehicle.brand?.isEmpty ?? false || vehicle.model?.isEmpty ?? false || selectedFuel == "Fuel Type"
   return false
    }
    
    @Published var skipNotification = false /// Skip notiification page when adding another car
    @Published var removeBack = false /// Remove back button when adding another car
    
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

enum Pages {
    case page1
    case page2
    case page3
    case page4
    case page5
}

