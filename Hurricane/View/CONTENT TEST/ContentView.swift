//
//  ContentView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 03/05/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @ObservedObject var dataVM : DataViewModel
    @StateObject var utilityVM = UtilityViewModel()
    
    @State var vehicleS : VehicleState = VehicleState()
    @State var expense : ExpenseState = ExpenseState()
    
    @State var filter : NSPredicate?
    
    @State var vehicleId: NSManagedObjectID?
    
    
    func deleteVehicle(at indexSet: IndexSet){
        indexSet.forEach{ index in
            let vehicle = dataVM.vehicleList[index]
            dataVM.vehicleList.remove(at: index)
            dataVM.deleteVehicleCoreData(vehicle: vehicle)
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
                    Text(fuelVM.defaultFuelType.label)
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
        
        let filterCurrentExpense = NSPredicate(format: "vehicle = %@",dataVM.getVehicle(vehicleID: dataVM.currentVehicle.first!.vehicleID)!)
        
        VStack{
            VStack{
//            Text(String(utilityVM.getTotalExpense(expenses: dataVM.expenseList)))
            Text(String(dataVM.totalExpense))
               
            TextField("Vehicle Name", text: $vehicleS.name)
                .textFieldStyle(.roundedBorder)
                .padding()
            TextField("Expenses Name", text: $expense.note)
                .textFieldStyle(.roundedBorder)
                .padding()
                TextField("Expenses Cost", value: $expense.price, formatter: NumberFormatter() )
                .textFieldStyle(.roundedBorder)
                .padding()
            }
            Button("Add veicolo"){
                vehicleS.fuelTypeOne = fuelVM.defaultSelectedFuel
                dataVM.addVehicle(vehicle: vehicleS)
                print(vehicleS)
            }
            Button("Remove all vehicles"){
                dataVM.removeAllVehicles()
            }
            Button("Remove all expenses"){
                dataVM.removeAllExpenses()
            }
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
                    try dataVM.updateVehicle(vehicleS)
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
                print(" expense list : \(dataVM.expenseList)")
            } label: {
                Text("print expense list")
            }

            
            Button("Get current vehicle"){
               
                    dataVM.getVehiclesCoreData(filter: filterCurrent, storage: { storage in
                        dataVM.currentVehicle = storage
                        
                    })
                
            }
            
            //MARK: FUEL TYPE
//            Menu{
//                Picker(selection: $fuelVM.defaultFuelType, label:
//                        EmptyView()){
//                        ForEach(FuelType.allCases, id: \.self) { fuel in
////                            Text(fuelVM.getFuelType(fuel: fuel))
//                            Text(fuel.label)
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
                dataVM.addExpense(expense: expense)
                dataVM.addNewExpensePriceToTotal(expense: expense)
                print("expense list \(dataVM.expenseList)")
            } label: {
                Text("Add Expenses")
            }

            
            VStack{
            List(){

                ForEach(dataVM.vehicleList,id:\.vehicleID){ vehicle in
                    VStack(alignment: .leading){
                    Text("Vehicle name: \(vehicle.name)")
                        Text("Fuel Type : \(vehicle.fuelTypeOne.label)")
                        Text("Second fuel: \(vehicle.fuelTypeTwo.label)")
                    }
                } .onDelete(perform: deleteVehicle)
                }
            
        
        
            if !dataVM.currentVehicle.isEmpty {
            ForEach(dataVM.expenseList, id: \.self) { expense in
               
                  Text("Expense: \(expense.note)")
//                Text("ciao")
                
                    }.onDelete(perform: dataVM.removeExpense(indexSet:))
            }
       
                    
            List {
                    ForEach(dataVM.currentVehicle,id:\.vehicleID){ current in
                        Text(current.name)
                    }
            }
            
        }
        .task{
            if !dataVM.currentVehicle.isEmpty {
                dataVM.getExpensesCoreData(filter: filterCurrentExpense, storage:  { storage in
                    dataVM.expenseList = storage
                })
                print("se current vehicle non è vuoto")
            }
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



