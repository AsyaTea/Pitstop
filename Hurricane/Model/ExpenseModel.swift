//
//  ExpenseModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//

import CoreData
import Foundation

struct ExpenseState: Hashable {
    var category: Int16?
    var date: Date = .now
    var note: String = ""
    var odometer: Float = 0.0
    var price: Float = 0.0
    var liters: Float?
    var priceLiter: Float?
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
    let expense: Expense

    var category: Int16 {
        expense.category
    }

    var fuelType: Int16 {
        expense.fuelType
    }

    var date: Date {
        expense.date
    }

    var note: String {
        expense.note ?? ""
    }

    var odometer: Float {
        expense.odometer
    }

    var liters: Float {
        expense.liters
    }

    var priceLiter: Float {
        expense.priceLiter
    }

    var price: Float {
        expense.price
    }

    var expenseID: NSManagedObjectID {
        expense.objectID
    }
}
