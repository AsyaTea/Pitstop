//
//  ExpenseModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//

import Foundation
import CoreData

struct ExpenseState: Hashable {
    var category: Int16?
    var date: Date = Date.now
    var note: String = ""
    var odometer: Float = 0.0
    var price: Float = 0.0
    var liters : Float?
    var priceLiter : Float?
    var expenseID: NSManagedObjectID?
    var fuelType: Int16?
    
}

extension ExpenseState {
    
    static func fromExpenseViewModel(vm: ExpenseViewModel) -> ExpenseState {
        var expenseS = ExpenseState()
        expenseS.category = vm.category
        expenseS.date = vm.date
        expenseS.note = vm.note
        expenseS.odometer = vm.odometer
        expenseS.price = vm.price
        expenseS.expenseID = vm.expenseID
        expenseS.fuelType = vm.fuelType
        expenseS.liters = vm.liters
        expenseS.priceLiter = vm.priceLiter
        return expenseS
        
    }
}

struct ExpenseViewModel: Hashable {
    let expense : Expense
    
    var category: Int16 {
        return expense.category
    }
    
    var fuelType: Int16 {
        return expense.fuelType
    }
    
    var date: Date {
        return expense.date
    }
    
    var note: String {
        return expense.note ?? ""
    }
    
    var odometer: Float {
        return expense.odometer
    }
    
    var liters: Float {
        return expense.liters
    }
    
    var priceLiter: Float {
        return expense.priceLiter
    }
    
    var price: Float {
        return expense.price
    }
    
    var expenseID: NSManagedObjectID {
        return expense.objectID
    }
    
}
