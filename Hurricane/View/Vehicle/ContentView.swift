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
    @State var expense : ExpenseState = ExpenseState()
    
    @State var filter : NSPredicate?
    
    @State var vehicleId: NSManagedObjectID?
    
    
    func deleteVehicle(at indexSet: IndexSet){
        indexSet.forEach{ index in
            let vehicle = vehicleVM.vehicleList[index]
            vehicleVM.vehicleList.remove(at: index)
            vehicleVM.deleteVehicleCoreData(vehicle: vehicle)
        }
    }
    
//    @StateObject var onboardingVM : OnboardingViewModel
    
    @StateObject var fuelVM = FuelViewModel()
    
    @FocusState var focusedField: FocusFieldBoarding?
    
    @State private var isTapped = false
    
    let haptic = UIImpactFeedbackGenerator(style: .light)
    
    var customLabel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36)
                .stroke(isTapped ? Palette.black : Palette.greyInput,lineWidth: 1)
                .background(isTapped ? Palette.greyLight : Palette.greyBackground)
                .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
            HStack{
                if isTapped {
                    Text(fuelVM.currentFuelType)
                        .font(Typography.TextM)
                    Spacer()
                } else {
                    Text("Fuel Type")
                        .font(Typography.TextM)
                    Spacer()
                }
            }
            .accentColor(isTapped ? Palette.black : Palette.greyInput)
            .padding(.leading,40)
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
        
        
        
        let filterCurrent = NSPredicate(format: "current = %@","1")
        let filterCurrentExpense = NSPredicate(format: "vehicle = %@",vehicleVM.getVehicle(vehicleID: vehicleVM.currentVehicle.first!.vehicleID)!)
        
        VStack{
            VStack{
            TextField("Vehicle Name", text: $vehicleS.name)
                .textFieldStyle(.roundedBorder)
                .padding()
            TextField("Expenses Name", text: $expense.note)
                .textFieldStyle(.roundedBorder)
                .padding()
            }
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
            
            
//            Button("Set current vehicle to last added:"){
//                for vehicle in vehicleVM.vehicleList {
////                    vehicleId = vehicle.vehicleID
////                    vehicleS.vehicleID = vehicleId
//                    vehicleS.vehicleID = vehicle.vehicleID
//                    print("LAST ADDED IS ",vehicleS.vehicleID)
//                }
//            }
            Button {
                print(" expense list : \(vehicleVM.expenseList)")
            } label: {
                Text("print expense list")
            }

            
            Button("Get current vehicle"){
                vehicleVM.getVehiclesCoreData(filter: filterCurrent, storage: { storage in
                    vehicleVM.currentVehicle = storage
                    
                })
            }
            
//            Menu{
//                Picker(selection: $fuelVM.selectedFuel, label:
//                        EmptyView()){
//                        ForEach(FuelType.allCases, id: \.self) { fuel in
//                            Text(fuelVM.getFuelType(fuel: fuel))
//
//                    }
//
//                }
//            } label: {
//               customLabel
//            }.onTapGesture {
//                isTapped = true
//            }

//            Button {
//                print(fuelVM.selectedFuel)
//            } label: {
//                Text("Selected fuel")
//            }
            
            Button {
                vehicleVM.addExpense(expense: expense)
                print("expense list \(vehicleVM.expenseList)")
            } label: {
                Text("Add Expenses")
            }

            
            VStack{
            List(){
                ForEach(vehicleVM.vehicleList,id:\.vehicleID){ vehicle in
                    VStack{
                    Text("Vehicle name: \(vehicle.name)")                   }
                } .onDelete(perform: deleteVehicle)
                }
        
        
        
            ForEach(vehicleVM.expenseList, id: \.self) { expense in
               
                  Text("Expense: \(expense.note)")
//                Text("ciao")
                
                    }.onDelete(perform: vehicleVM.removeExpense(indexSet:))
        
               
       
                    
            List {
                    ForEach(vehicleVM.currentVehicle,id:\.vehicleID){ current in
                        Text(current.name)
                    }
            }
            
        }
        .task{
            vehicleVM.getExpensesCoreData(filter: filterCurrentExpense, storage:  { storage in
                vehicleVM.expenseList = storage
            })
        }
        
        //Floating button
//            .overlay(
//                VStack{
//                    Spacer(minLength: UIScreen.main.bounds.size.height * 0.42)
//                    Button(action: {
//
//                        vehicleVM.addExpense(expense: expense)
//    //                        vehicleVM.getExpenses()
//                    }, label: {
//                        ZStack{
//                            Rectangle()
//                                .frame(width: 343, height: 48, alignment: .center)
//                                .cornerRadius(43)
//                                .foregroundColor(.black)
//                            Text("+ Add expense")
//                                .foregroundColor(.white)
//                        }
//
//                    })
//                    Spacer()
//                }
//    //                    .padding(.top,50)
//            )
         
            
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



