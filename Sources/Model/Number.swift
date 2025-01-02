//
//  Number.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 02/01/25.
//

import Foundation
import SwiftData

@Model
final class Number2: Identifiable {
    @Attribute(.unique)
    var uuid: UUID

    var title: String
    var telephone: String

    var vehicle: Vehicle2?

    init(
        uuid: UUID = UUID(),
        title: String,
        telephone: String,
        vehicle: Vehicle2? = nil
    ) {
        self.uuid = uuid
        self.title = title
        self.telephone = telephone
        self.vehicle = vehicle
    }

    func saveToModelContext(context: ModelContext) throws {
        context.insert(self)
        try context.save()
        print("Number \(telephone) for \(String(describing: vehicle?.name)) saved successfully!")
    }
}
