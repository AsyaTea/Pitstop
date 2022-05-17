//
//  ContentView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 03/05/22.
//

import SwiftUI
import CoreData
//
struct ContentView: View {
    
    @StateObject private var vehicleVM = DataViewModel()
    @State var vehicle : VehicleState = VehicleState()
    @State var expense : ExpenseModel = ExpenseModel()
    
    @State var filter : NSPredicate?
    
    @State var vehicleId: NSManagedObjectID?
    
    
    private func deleteVehicle(at indexSet: IndexSet){
        indexSet.forEach{ index in
            let vehicle = vehicleVM.vehicleList[index]
            
            vehicleVM.removeVehicle(vehicle: vehicle)
            
            vehicleVM.getVehicles()
        }
    }
    
    func save() {
        do {
            try vehicleVM.updateVehicle(vehicle)
        } catch {
            print(error)
        }
    }

    // MARK: PROVA DI AGGIUNTA
    var body: some View {
        VStack{
            TextField("Vehicle Name", text: $vehicle.name)
                .textFieldStyle(.roundedBorder)
                .padding()
            TextField("Expenses Name", text: $expense.note.toUnwrapped(defaultValue: ""))
                .textFieldStyle(.roundedBorder)
                .padding()
            Text("ciao")
            Button("Add veicolo"){
                vehicleVM.addVehicle(vehicle: vehicle)               
                print(vehicle)
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
            Button ("Update last car") {
                //assegnare a vehicle state il vehicle viewmodel
//                try vehicleVM.getVehicleById(vehicleId: vehicleId) {
//                    throw VehicleError.VehicleNotFount
//                }
                do {
                    try vehicle.vehicleID = vehicleVM.getVehicleById(vehicleId: vehicleId!).vehicleID
                } catch {
                    print("Erorreeeeee")
                }
                save()
            }
            
            Button("Set current vehicle to last added:"){
                for vehicle in vehicleVM.vehicleList {
                    vehicleId = vehicle.vehicleID
                }
            }
            
            List(){
                ForEach(vehicleVM.vehicleList,id:\.vehicleID){ vehicle in
                    VStack{
                    
                    Text("Vehicle name: \(vehicle.name ?? "")")
                    
                      
                        
                    }
                    
                }
                .onDelete(perform: deleteVehicle)
                ForEach(vehicleVM.expenses) { expenses in
                    Text("Exp: \(expenses.note ?? "" + expenses.note! ?? "")")
                    Text("Vehicle appart:\(expenses.vehicle?.name ?? "" )")

                } .onDelete(perform: vehicleVM.removeExpense(indexSet:))
                    
                
            }
            //Floating button
            .overlay(
                VStack{
                    Spacer(minLength: UIScreen.main.bounds.size.height * 0.42)
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
//extension Binding {
//    func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
//        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
//    }
//}



