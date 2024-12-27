//
//  Vehicle2.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 27/12/24.
//

import Foundation
import SwiftData

@Model
final class Vehicle2: Identifiable {
    @Attribute(.unique)
    var uuid: UUID

    var name: String
    var brand: String
    var model: String
    var mainFuelType: FuelType
    var secondaryFuelType: FuelType?
    var odometer: Float
    var plate: String?
    var year: Int?

    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \Expense2.vehicle)
    var expenses: [Expense2] = []

    @Relationship(deleteRule: .cascade, inverse: \Number2.vehicle)
    var numbers: [Number2] = []

    init(
        uuid: UUID = UUID(),
        name: String,
        brand: String,
        model: String,
        mainFuelType: FuelType = .gasoline,
        secondaryFuelType: FuelType? = nil,
        odometer: Float,
        plate: String? = nil,
        year: Int? = nil
    ) {
        self.uuid = uuid
        self.name = name
        self.brand = brand
        self.model = model
        self.mainFuelType = mainFuelType
        self.secondaryFuelType = secondaryFuelType
        self.odometer = odometer
        self.plate = plate
        self.year = year
    }

    func saveToModelContext(context: ModelContext) throws {
        context.insert(self)
        try context.save()
        print("Vehicle \(name) saved successfully!")
    }

    static func mock() -> Vehicle2 {
        Vehicle2(name: "", brand: "", model: "", odometer: 0)
    }
}

// TODO: Implement

@Model
final class Expense2: Identifiable {
    @Attribute(.unique)
    var uuid: UUID

    var vehicle: Vehicle2?

    init(uuid: UUID, vehicle: Vehicle2? = nil) {
        self.uuid = uuid
        self.vehicle = vehicle
    }
}

@Model
final class Number2: Identifiable {
    @Attribute(.unique)
    var uuid: UUID

    var vehicle: Vehicle2?

    init(uuid: UUID, vehicle: Vehicle2? = nil) {
        self.uuid = uuid
        self.vehicle = vehicle
    }
}
