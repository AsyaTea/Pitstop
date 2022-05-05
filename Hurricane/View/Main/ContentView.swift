//
//  ContentView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 03/05/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vehicleVM = DataViewModel()
    
    //    @State var vehicle : Vehicle = Vehicle()
    @State var vehicle : VehicleModel = VehicleModel()
    @State var expense : ExpenseModel = ExpenseModel()
    
    @State var filter : NSPredicate?

    // MARK: PROVA DI AGGIUNTA
    var body: some View {
        VStack{
            TextField("Vehicle Name", text: $vehicle.name.toUnwrapped(defaultValue: ""))
                .textFieldStyle(.roundedBorder)
                .padding()
            TextField("Expenses Name", text: $expense.name.toUnwrapped(defaultValue: ""))
                .textFieldStyle(.roundedBorder)
                .padding()
            Text("ciao")
            Button("Add veicolo"){
                vehicleVM.addVehicle(vehicle: vehicle)
            }
            Button("Remove all vehicles"){
                vehicleVM.removeAllVehicles()
            }
            Button("Remove all expenses"){
                vehicleVM.removeAllExpenses()
            }
            Button ("Filter x Expenses"){
                filter = NSPredicate(format: "vehicle ==  %@", vehicleVM.currVehicle)
                vehicleVM.getExpenses(filter: filter)
            }
            
            Button("Set current vehicle to last added:"){
                for vehicle in vehicleVM.vehicles {
                    
                    vehicleVM.currVehicle = vehicle
                    print(vehicleVM.currVehicle)
                }
            }
            
            List(){
                ForEach(vehicleVM.vehicles){ vehicle in
                    VStack{
                    
                    Text("Vehicle name: \(vehicle.name ?? "")")
                    
                      
                        
                    }
                    
                }
                .onDelete(perform: vehicleVM.removeVehicle)
                ForEach(vehicleVM.expenses) { expenses in
                        Text("Exp: \(expenses.name ?? "")")
                    Text("Vehicle appart:\(expenses.vehicle?.name ?? "" )")

                } .onDelete(perform: vehicleVM.removeExpense(indexSet:))
                
            }
            //Floating button
            .overlay(
                VStack{
                    Spacer(minLength: UIScreen.main.bounds.size.height * 0.62)
                    Button(action: {
                        
                        vehicleVM.addExpense(expense: expense)
//                        vehicleVM.getExpenses()
                    }, label: {
                        ZStack{
                            Rectangle()
                                .frame(width: 343, height: 48, alignment: .center)
                                .cornerRadius(43)
                                .foregroundColor(.black)
                            Text("+ Add expense")
                                .foregroundColor(.white)
                        }
                        
                    })
                    Spacer()
                }
//                    .padding(.top,50)
            )
            
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



