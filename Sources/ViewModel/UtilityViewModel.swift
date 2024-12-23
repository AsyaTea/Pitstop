//
//  UtilityViewModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import Foundation

class UtilityViewModel: ObservableObject {
    @Published var currency = "€"
    @Published var unit = "km"

    @Published var totalVehicleCost: Float = 0.0

    @Published var expenseToEdit = ExpenseState()
    @Published var reminderToEdit = ReminderState()

    init() {}

//    func getTotalExpense(expenses: [ExpenseViewModel]) -> Float {
//        for expense in expenses {
//            totalVehicleCost += expense.price
//        }
//        totalExpense = totalVehicleCost
//        print("sum cost : \(totalVehicleCost)")
//        return totalVehicleCost
//    }
}
