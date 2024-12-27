//
//  VehicleViewModel.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 28/12/24.
//

import Foundation

class VehicleManager: ObservableObject {
    @Published var currentVehicle: Vehicle2 = .mock() {
        didSet {
            saveVehicleToUserDefaults(vehicle: currentVehicle)
        }
    }

    private let userDefaultsKey = "currentVehicle"

    init() {
        if let vehicle = loadVehicleFromUserDefaults() {
            currentVehicle = vehicle
        }
    }

    private func loadVehicleFromUserDefaults() -> Vehicle2? {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            if let loadedVehicle = try? decoder.decode(Vehicle2.self, from: savedData) {
                return loadedVehicle
            }
        }
        return nil
    }

    private func saveVehicleToUserDefaults(vehicle: Vehicle2) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(vehicle) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
}
