//
//  VehicleModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//

import CoreData
import Foundation

struct VehicleViewModel: Hashable {
    let vehicle: Vehicle

    var expense: NSSet {
        vehicle.expenses ?? NSSet()
    }

    var current: NSNumber {
        vehicle.current ?? 0
    }

    var brand: String {
        vehicle.brand ?? ""
    }

    var fuelTypeOne: FuelType {
        get { FuelType(rawValue: Int(vehicle.fuelTypeOne)) ?? .gasoline }
        set { vehicle.fuelTypeOne = Int16(newValue.rawValue) }
    }

    var fuelTypeTwo: FuelType {
        get { FuelType(rawValue: Int(vehicle.fuelTypeTwo)) ?? .none }
        set { vehicle.fuelTypeTwo = Int16(newValue.rawValue) }
    }

    var model: String {
        vehicle.model ?? ""
    }

    var name: String {
        vehicle.name ?? ""
    }

    var odometer: Float {
        vehicle.odometer
    }

    var plate: String {
        vehicle.plate ?? ""
    }

    var vehicleID: NSManagedObjectID {
        vehicle.objectID
    }

    var year: Int32 {
        vehicle.year
    }
}

struct VehicleState: Hashable {
    var current: NSNumber?
    var brand: String = ""
    var fuelTypeOne: Int16 = 1
    var fuelTypeTwo: Int16?
    var model: String = ""
    var name: String = ""
    var odometer: Float = 0.0
    var plate: String = ""
    var vehicleID: NSManagedObjectID?
    var year: Int32 = 0
}

extension VehicleState {
    static func fromVehicleViewModel(vm: VehicleViewModel) -> VehicleState {
        var vehicleS = VehicleState()
        vehicleS.current = vm.current
        vehicleS.vehicleID = vm.vehicleID
        vehicleS.odometer = vm.odometer
        vehicleS.brand = vm.brand
        vehicleS.fuelTypeOne = Int16(vm.fuelTypeOne.rawValue)
        vehicleS.fuelTypeTwo = Int16(vm.fuelTypeTwo.rawValue)
        vehicleS.name = vm.name
        vehicleS.year = vm.year
        vehicleS.model = vm.model
        vehicleS.plate = vm.plate
        return vehicleS
    }
}
