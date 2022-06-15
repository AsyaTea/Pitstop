//
//  TopBarView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//

import SwiftUI

struct TopNav : View {
    
    @ObservedObject var dataVM: DataViewModel
    @StateObject var utilityVM: UtilityViewModel
    @ObservedObject var categoryVM: CategoryViewModel
    
    var offset: CGFloat
    let maxHeight: CGFloat
    var topEdge: CGFloat

    @State private var showingAllCars = false
    @State private var showReminders = false
    
    let filter = NSPredicate(format: "current == %@","1")
    
    var brandModelString : String {
        return "\(dataVM.currentVehicle.first?.brand ?? "brand") \(dataVM.currentVehicle.first?.model ?? "model")"
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Button(action: {
                    showingAllCars.toggle()
                }, label: {
                    HStack{
                        Text(dataVM.currentVehicle.first?.name ?? "Default's car ")
                            .foregroundColor(Palette.blackHeader)
                            .font(Typography.headerXL)
                            .opacity(fadeOutOpacity())
                        Image("arrowLeft")
                            .resizable()
                            .foregroundColor(Palette.blackHeader)
                            .frame(width: 10, height: 14)
                            .rotationEffect(Angle(degrees: 270))
                            .padding(.top,3)
                            .padding(.leading,-3)
                    }
                    .padding(.leading,-1)
                    .opacity(fadeOutOpacity())
                })
                .disabled(fadeOutOpacity() < 0.35)
                .confirmationDialog(String(localized: "Select a vehicle"), isPresented: $showingAllCars, titleVisibility: .hidden) {
                    ForEach(dataVM.vehicleList,id:\.vehicleID){ vehicle in
                        Button(vehicle.name) {
                            //DEVO SETTARE IL CURRENT VEHICLE
                            var vehicleS = VehicleState.fromVehicleViewModel(vm: vehicle)
                            dataVM.setAllCurrentToFalse()
                            vehicleS.current = 1 // SETTO IL CURRENT TO TRUE
                    
                            do{
                                if(vehicleS.vehicleID != nil){
                                try dataVM.updateVehicle(vehicleS)
                                    print("updato to current")
                                    dataVM.currentVehicle.removeAll()
                                    dataVM.currentVehicle.append(vehicle)
                                    let filterCurrentExpense = NSPredicate(format: "vehicle = %@", (dataVM.currentVehicle.first?.vehicleID)!)
                                    dataVM.getExpensesCoreData(filter: filterCurrentExpense) { storage in
                                        dataVM.expenseList = storage
                                        dataVM.getTotalExpense(expenses: storage)
                                        categoryVM.retrieveAndUpdate(vehicleID: dataVM.currentVehicle.first!.vehicleID)
                                    }
                            }
                            else{
                                print("error")
                            }
                            }
                            catch{
                                print(error)
                            }
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                        .background(.black)
                        .foregroundColor(.red)
                }
                
                
                
                Spacer()
                HStack{
                    //MARK: TO REMOVE
//                    Button(action: {
//
//                    }, label: {
//                        ZStack{
//                            Rectangle()
//                                .foregroundColor(Palette.white)
//                                .cornerRadius(37)
//                                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.04)
//                                .shadowGrey()
//                            HStack{
//                                Text("Per month")
//                                    .foregroundColor(Palette.black)
//                                    .font(Typography.ControlS)
//                                Image("arrowDown")
//
//                            }
//                        }.opacity(fadeOutOpacity())
//                    })
                    
                    ZStack{
                        Button(action: {
                            showReminders.toggle()
                        }, label: {
                            ZStack{
                                Circle()
                                    .foregroundColor(Palette.whiteHeader)
                                    .frame(width: UIScreen.main.bounds.width * 0.09, height: UIScreen.main.bounds.height * 0.04)
                                    .shadowGrey()
                                Image("bellHome")
                            }
                        })
                    }
                }
                .padding(.top,2)
            }
            Text(brandModelString)
                .foregroundColor(Palette.blackHeader)
                .font(Typography.TextM)
                .padding(.top,-12)
                .opacity(fadeOutOpacity())
        }
        .task{
            //Fetch current vehicle from DB
            dataVM.getVehiclesCoreData(filter: filter, storage:{ storage in
                dataVM.currentVehicle = storage
            })
        }
        .overlay(
            VStack(alignment: .center,spacing: 2){
                Text(dataVM.currentVehicle.first?.name ?? "Default's car ")
                    .font(Typography.headerM)
                    .foregroundColor(Palette.blackHeader)
                Text(brandModelString)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.blackHeader)
            }
                .opacity(
                    withAnimation(.easeInOut){
                        fadeInOpacity()
                    })
                .padding(.bottom,15)
        )
        .sheet(isPresented: $showReminders){
            ReminderView(dataVM: dataVM, utilityVM: utilityVM)
        }
    }
    
    // Opacity to let appear items in the top bar
    func fadeInOpacity() -> CGFloat {
        // to start after the main content vanished
        // we nee to eliminate 70 from the offset
        // to get starter..
        let progress = -(offset + 70) / (maxHeight - (60 + topEdge * 3.2))
        
        return progress
    }
    
    // Opacity to let items in top bar disappear on scroll
    func fadeOutOpacity() -> CGFloat {
        // 70 = Some rnadom amount of time to visible on scroll
        let progress = -offset / 70
        let opacity = 1 - progress
        
        return offset < 0 ? opacity : 1
    }
    
    
    
}
