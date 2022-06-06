//
//  AddExpenseViewModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import Foundation

class AddExpenseViewModel : ObservableObject {
    
    //List picker categories
    @Published var category : Int16 = Int16(Category.fuel.rawValue)
    @Published var fuel : Int16 = 0
    @Published var selectedCategory : String = "Fuel"
    @Published var selectedFuel : String = ""
    
    //Reminders
    @Published var selectedCategoryReminder =  "Maintenance"
    let categoryReminder = ["Maintenance", "Insurance","Road tax","Tolls","Parking","Other"]
    @Published var selectedRepeat = "Never"
    let repeatTypes = ["Never", "Daily", "Weekdays","Weekends", "Weekly","Monthly","Every 3 Months","Every 6 Months","Yearly"]
    @Published var selectedBased = "Date"
    let basedTypes = ["Date","Distance"]
    
    //Vars to store the input in fields
    @Published var price : Float = 0.0
    @Published var date = Date()
    @Published var liters : Float = 0.0
    @Published var pricePerLiter : Float = 0.0
    @Published var note : String = ""
    @Published var odometer : String = "" ///Var  to store the odometer value in expense
   
    
    //Segmented picker tabs
    @Published var currentPickerTab : String = "Expense"
    @Published var odometerTab: String = ""
    @Published var priceTab : String = ""
    
    @Published var expenseS = ExpenseState()
    
    
    func createExpense() {
        expenseS.price = price
        expenseS.liters = liters
        expenseS.priceLiter = pricePerLiter
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
        if(tab == "Expense"){
            price = 0
            priceTab = ""
            selectedCategory = "Fuel"
            odometer = ""
            odometerTab = ""
            selectedRepeat = "Never"
            date = Date.now
            note = ""
        }
        if(tab == "Odometer"){
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
