//
//  AddExpenseViewModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import Foundation

class AddExpenseViewModel : ObservableObject {
    
    //List picker categories
    @Published var selectedCategory = "Fuel"
    let categoryTypes = ["Fuel", "Maintenance", "Insurance","Road tax","Tolls","Fines","Parking","Other"]
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
    @Published var odometer : Float = 0 ///Var  to store the odometer value in expense
    
    //Segmented picker tabs
    @Published var currentPickerTab : String = "Expense"
    @Published var priceTab : String = ""
    @Published var odometerTab : String = ""  /// Var to store the odometer value in odometer tab
    @Published var reminderTab : String = "" /// Var to store the reminder title in reminder tab
    
    @Published var expenseS = ExpenseState()
    
    
    func createExpense() {
        expenseS.price = price
        expenseS.liters = liters
        expenseS.priceLiter = pricePerLiter
        expenseS.odometer = odometer
        expenseS.note = note
    }

    func resetTabFields(tab : String){
        if(tab == "Expense"){
            price = 0
            priceTab = ""
            selectedCategory = "Fuel"
            odometer = 0
            selectedRepeat = "Never"
            date = Date.now
            note = ""
        }
        if(tab == "Odometer"){
            odometerTab = ""
            note = ""
            date = Date.now
        }
        if(tab == "Reminder"){
            reminderTab = ""
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
