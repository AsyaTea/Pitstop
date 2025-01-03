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

    @Relationship(deleteRule: .cascade, inverse: \Number.vehicle)
    var numbers: [Number] = []

    @Relationship(deleteRule: .cascade, inverse: \FuelExpense.vehicle)
    var fuelExpenses: [FuelExpense] = []

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

    // Custom decode method to handle relationships
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(UUID.self, forKey: .uuid)
        name = try container.decode(String.self, forKey: .name)
        brand = try container.decode(String.self, forKey: .brand)
        model = try container.decode(String.self, forKey: .model)
        mainFuelType = try container.decode(FuelType.self, forKey: .mainFuelType)
        secondaryFuelType = try container.decodeIfPresent(FuelType.self, forKey: .secondaryFuelType)
        odometer = try container.decode(Float.self, forKey: .odometer)
        plate = try container.decodeIfPresent(String.self, forKey: .plate)
        year = try container.decodeIfPresent(Int.self, forKey: .year)
    }

    func saveToModelContext(context: ModelContext) throws {
        context.insert(self)
        try context.save()
        print("Vehicle \(name) saved successfully!")
    }

    static func mock() -> Vehicle2 {
        Vehicle2(name: "Default car", brand: "Brand", model: "XYZ", odometer: 0.0)
    }

    func calculateTotalFuelExpenses() -> String {
        let total = fuelExpenses.reduce(0.0) { $0 + $1.totalPrice }
        return String(format: "%.2f", total)
    }
}

extension Vehicle2: Codable {
    enum CodingKeys: String, CodingKey {
        case uuid, name, brand, model, mainFuelType, secondaryFuelType, odometer, plate, year, expenses, numbers
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(name, forKey: .name)
        try container.encode(brand, forKey: .brand)
        try container.encode(model, forKey: .model)
        try container.encode(mainFuelType, forKey: .mainFuelType)
        try container.encode(secondaryFuelType, forKey: .secondaryFuelType)
        try container.encode(odometer, forKey: .odometer)
        try container.encode(plate, forKey: .plate)
        try container.encode(year, forKey: .year)
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
