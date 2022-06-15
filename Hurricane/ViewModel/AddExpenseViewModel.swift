//
//  AddExpenseViewModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import Foundation
import SwiftUI

class AddExpenseViewModel : ObservableObject {
    
    //List picker categories
    @Published var category : Int16 = Int16(Category.fuel.rawValue)
    @Published var fuel : Int16 = 0
    @Published var selectedCategory : String = String(localized:"Fuel")
    @Published var selectedFuel : String = ""
    
    //Reminders
    @Published var selectedCategoryReminder = String(localized: "Maintenance")
//    let categoryReminder = ["Maintenance", "Insurance","Road tax","Tolls","Parking","Other"]
    @Published var selectedRepeat = "Never"
    let repeatTypes = ["Never", "Daily", "Weekdays","Weekends", "Weekly","Monthly","Every 3 Months","Every 6 Months","Yearly"]
    @Published var selectedBased = NSLocalizedString("Date", comment: "")
    let basedTypes = ["Date"] 
    
    //Vars to store the input in fields
    @Published var price : String = ""
    @Published var date = Date()
    @Published var liters : String = ""
    @Published var pricePerLiter : String = ""
    @Published var note : String = ""
    @Published var odometer : String = "" ///Var  to store the odometer value in expense
   
    
    //Segmented picker tabs
    @Published var currentPickerTab : String = String(localized: "Expense")
    @Published var odometerTab: String = ""
    @Published var priceTab : String = ""
    
    @Published var expenseS = ExpenseState()
    
    
    func createExpense() {
        let replacedPrice = String(price.map {
        $0 == "," ? "." : $0 })
        expenseS.price = Float(replacedPrice) ?? 0.0
        let replacedLiters = String(liters.map {
        $0 == "," ? "." : $0 })
        expenseS.liters = Float(replacedLiters)
        let replacedPriceLiter = String(pricePerLiter.map {
        $0 == "," ? "." : $0 })
        expenseS.priceLiter = Float(replacedPriceLiter)
        if(!odometer.isEmpty){
            expenseS.odometer = Float(odometer) ?? 0.0
        }
        else{
            expenseS.odometer = Float(odometerTab) ?? 0.0
        }
        expenseS.note = note
        expenseS.category = category
        expenseS.fuelType = fuel
    }

    func resetTabFields(tab : String){
        if(tab == String(localized:"Expense")){
            price = ""
            priceTab = ""
            selectedCategory = String(localized:"Fuel")
            odometer = ""
            odometerTab = ""
            selectedRepeat = String(localized: "Never")
            date = Date.now
            note = ""
        }
        if(tab == String(localized:"Odometer")){
            odometerTab = ""
            odometer = ""
            note = ""
            date = Date.now
        }
    }
    
//
//    func getLiters(cost: Float, priceLiter: Float){
//        self.liters = cost/priceLiter
//    }
//
//    func getPrice(cost: Float, liters: Float) {
//        self.pricePerLiter = cost/liters
//    }
    
}
