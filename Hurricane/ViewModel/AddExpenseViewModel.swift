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
    @Published var selectedFuelType = "Default"
    let fuelTypes = ["Default", "Secondary"]
    @Published var selectedBased = "Date"
    let basedTypes = ["Date","Distance"]
    
    //Vars to store the input in fields
    @Published var date = Date()
    @Published var liters : String = ""
    @Published var pricePerLiter : String = ""
    @Published var note : String = ""
    @Published var odometer : String = "" ///Var  to store the odometer value in expense
    
    //Segmented picker tabs
    @Published var currentPickerTab : String = "Expense"
    @Published var priceTab : String = ""
    @Published var odometerTab : String = ""  /// Var to store the odometer value in odometer tab
    @Published var reminderTab : String = "" /// Var to store the reminder title in reminder tab
   
    
    func resetTabFields(tab : String){
        if(tab == "Expense"){
            priceTab = ""
            selectedCategory = "Fuel"
            odometer = ""
            selectedFuelType = "Default"
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
    
//    func createExpense() -> ExpenseModel {
//        let newExpense = ExpenseModel(date: self.date, isRecursive: false, name: "Expense 1", note: self.note, odometer: Int32(self.odometer), price: Float(self.priceTab), type: Int16(self.selectedCategory))
//        return newExpense
//        
//    }
}
