//
//  VehicleModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//

import Foundation
import CoreData

struct VehicleViewModel : Hashable {
    
    let vehicle : Vehicle
    
    var expense : NSSet  {
        return vehicle.expenses ?? NSSet()
    }
    
    var current: NSNumber {
        return vehicle.current ?? 0
    }
    
    var brand : String {
        return vehicle.brand ?? ""
    }
    
    //    var document : Data {
    //        return vehicle.date
    //    }
    
    var fuelTypeOne: FuelType {
        get {return FuelType.init(rawValue: Int(vehicle.fuelTypeOne)) ?? .gasoline}
        set {vehicle.fuelTypeOne = Int16(newValue.rawValue)}
    }
    
    var fuelTypeTwo: FuelType {
        get {return FuelType.init(rawValue: Int(vehicle.fuelTypeTwo)) ?? .none}
        set {vehicle.fuelTypeTwo = Int16(newValue.rawValue)}
    }
    
    var model : String{
        return vehicle.model ?? ""
    }
    
    var name : String {
        return vehicle.name ?? ""
    }
    
    var odometer : Float{
        return vehicle.odometer
    }
    
    var plate : String {
        return vehicle.plate ?? ""
    }
    
    var vehicleID: NSManagedObjectID {
        return vehicle.objectID
    }
    
    var year: Int32 {
        return vehicle.year
    }
}


struct VehicleState : Hashable {
    
    var current : NSNumber?
    var brand : String = ""
    var document : Data?
    var fuelTypeOne: Int16 = 0
    var fuelTypeTwo: Int16?
    var model : String = ""
    var name : String = ""
    var odometer : Float = 0.0
    var plate : String = ""
    var vehicleID: NSManagedObjectID?
    var year: Int32 = 0
}

extension VehicleState {
    
    static func fromVehicleViewModel(vm: VehicleViewModel) -> VehicleState{
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
