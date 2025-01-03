//
//  FuelExpense.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 02/01/25.
//

import Foundation
import SwiftData

@Model
class FuelExpense: Identifiable {
    @Attribute(.unique)
    var uuid: UUID

    var totalPrice: Float
    var quantity: Float
    var pricePerUnit: Float
    var odometer: Float
    var fuelType: FuelType
    var date: Date

    init(
        uuid: UUID = UUID(),
        totalPrice: Float,
        quantity: Float,
        pricePerUnit: Float,
        odometer: Float,
        fuelType: FuelType,
        date: Date,
        vehicle: Vehicle2
    ) {
        self.uuid = uuid
        self.totalPrice = totalPrice
        self.quantity = quantity
        self.pricePerUnit = pricePerUnit
        self.odometer = odometer
        self.fuelType = fuelType
        self.date = date
        self.vehicle = vehicle
    }

    var vehicle: Vehicle2

    static func mock() -> FuelExpense {
        .init(totalPrice: 0, quantity: 0, pricePerUnit: 0, odometer: 0, fuelType: .diesel, date: .now, vehicle: .mock())
    }
}
