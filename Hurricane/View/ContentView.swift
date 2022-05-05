//
//  ContentView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 03/05/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vehicleVM = VehicleViewModel()
    
    //    @State var vehicle : Vehicle = Vehicle()
    @State var vehicle : VehicleModel = VehicleModel()
    @State var expense : ExpenseModel = ExpenseModel()
    

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
            Button("Remove all"){
                vehicleVM.removeAllVehicles()
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
                    
                    Text(vehicle.name ?? "")
                    
                        ForEach(vehicleVM.expenses) { expenses in
                                Text("Exp: \(expenses.name ?? "")")

                        }
                        
                    }
                    
                }
                .onDelete(perform: vehicleVM.removeVehicle)
                
            }
            //Floating button
            .overlay(
                VStack{
                    Spacer(minLength: UIScreen.main.bounds.size.height * 0.62)
                    Button(action: {
                        
//                        expenseVM.addExpenses(expense: expense)
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



