//
//  ContentView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 03/05/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vehicleVM = VehicleViewModel()
//    @State var vehicle : Vehicle = Vehicle(entity: "Vehicle")
    
    
    // MARK: PROVA DI AGGIUNTA
    var body: some View {
        VStack{
            TextField("Name", text: $vehicleVM.name)
            Text("ciao")
            Button("Add"){
                vehicleVM.addVehicle()
            }
            Button("Remove all"){
                vehicleVM.removeAllVehicles()
            }
            List(){
                ForEach(vehicleVM.vehicles){ vehicle in
                    Text(vehicle.name ?? "")
                    
                }
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    var vehicle = Vehicle()
//    static var previews: some View {
//        ContentView(vehicle: vehicle)
//    }
//}

//Need to this to wrap optional values when Binding
extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}


