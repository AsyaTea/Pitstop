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
    
    @ObservedObject var vehicleVM : DataViewModel
    @State var vehicleS : VehicleState = VehicleState()
    @State var expense : ExpenseModel = ExpenseModel()
    
    @State var filter : NSPredicate?
    
    @State var vehicleId: NSManagedObjectID?
    
    
    func deleteVehicle(at indexSet: IndexSet){
        indexSet.forEach{ index in
            let vehicle = vehicleVM.vehicleList[index]
            vehicleVM.vehicleList.remove(at: index)
            vehicleVM.removeVehicle(vehicle: vehicle)
        }
    }
    
//    func save() {
//        do {
//            try vehicleVM.updateVehicle(vehicleS)
//        } catch {
//            print(error)
//        }
//    }

    // MARK: PROVA DI AGGIUNTA
    var body: some View {
        
        var filterCurrent = NSPredicate(format: "current = %@","1")
        
        VStack{
            TextField("Vehicle Name", text: $vehicleS.name)
                .textFieldStyle(.roundedBorder)
                .padding()
            TextField("Expenses Name", text: $expense.note.toUnwrapped(defaultValue: ""))
                .textFieldStyle(.roundedBorder)
                .padding()
            Text("ciao")
            Button("Add veicolo"){
                vehicleVM.addVehicle(vehicle: vehicleS)
                print(vehicleS)
            }
            Button("Remove all vehicles"){
                vehicleVM.removeAllVehicles()
            }
//            Button("Remove all expenses"){
//                vehicleVM.removeAllExpenses()
//            }
//            Button ("Filter x Expenses"){
//                filter = NSPredicate(format: "vehicle ==  %@", vehicleVM.currVehicle)
//                vehicleVM.getExpenses(filter: filter)
//            }
            
//            Button ("Update last car") {
//                //assegnare a vehicle state il vehicle viewmodel
////                try vehicleVM.getVehicleById(vehicleId: vehicleId) {
////                    throw VehicleError.VehicleNotFount
////                }
//                do {
//                    try vehicleS.vehicleID = vehicleVM.getVehicleById(vehicleId: vehicleId!).vehicleID
//                } catch {
//                    print("Erorreeeeee")
//                }
//                save()
//            }
            
            Button ("UPDATE V2") {
                do{
                    if(vehicleS.vehicleID != nil){
                    try vehicleVM.updateVehicle(vehicleS)
                }
                else{
                    print("error")
                }
                }
                catch{
                    print(error)
                }
                
            }
            
            Button("Set current vehicle to last added:"){
                for vehicle in vehicleVM.vehicleList {
//                    vehicleId = vehicle.vehicleID
//                    vehicleS.vehicleID = vehicleId
                    vehicleS.vehicleID = vehicle.vehicleID
                    print("LAST ADDED IS ",vehicleS.vehicleID)
                }
            }
            
            Button("Get current vehicle"){
                vehicleVM.getVehiclesCoreData(filter: filterCurrent, storage: {storage in
                    vehicleVM.currentVehicle = storage
                    
                })
            }
            
            List(){
                ForEach(vehicleVM.vehicleList,id:\.vehicleID){ vehicle in
                    VStack{
                    
                    Text("Vehicle name: \(vehicle.name)")
                    
                      
                        
                    }
                } .onDelete(perform: deleteVehicle)
                }
               
            
//                ForEach(vehicleVM.expenses) { expenses in
//                    Text("Exp: \(expenses.note ?? "" + expenses.note! ?? "")")
//                    Text("Vehicle appart:\(expenses.vehicle?.name ?? "" )")
//
//                } .onDelete(perform: vehicleVM.removeExpense(indexSet:))
                    
            List{
                    ForEach(vehicleVM.currentVehicle,id:\.vehicleID){ current in
                        Text(current.name)
                    }
            }//Floating button
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



