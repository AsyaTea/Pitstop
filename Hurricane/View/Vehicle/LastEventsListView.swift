//
//  LastEventsListView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 23/05/22.
//

import SwiftUI

struct LastEventsListView: View {
    
    
    @State private var pickerTabs = ["Overview", "Cost", "Fuel", "Odometer"]
    
    @State private var showEditExpense = false
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var dataVM : DataViewModel
    @ObservedObject var utilityVM : UtilityViewModel
    @ObservedObject var categoryVM : CategoryViewModel
    
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Palette.greyBackground
                    .ignoresSafeArea()
                VStack {
                    
                    //MARK: CATEGORIES FILTER
                    FiltersRow(dataVM: dataVM)
                    ScrollView(.vertical, showsIndicators: false){
                        //MARK: MONTHS
                        ZStack{
                            Rectangle()
                                .frame(height: UIScreen.main.bounds.height * 0.035)
                                .foregroundColor(Palette.greyLight)
                            HStack{
                                Text("June")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.ControlS)
                                Spacer()
                                Text("1 984,42 $")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.ControlS)
                            }
                            .padding()
                        }
                        
                        if(dataVM.expenseFilteredList.isEmpty){
                            HStack{
                                Text("There are no events now")
                                    .font(Typography.TextM)
                                    .foregroundColor(Palette.greyMiddle)
                                Spacer()
                            }
                            .padding()
                        }
                        else{
                            ForEach(dataVM.expenseFilteredList.reversed(),id:\.self) { expense in
                                CategoryComponent(
                                    category: Category.init(rawValue: Int(expense.category )) ?? .other,
                                    date: expense.date, cost: String(expense.price)
                                )
                            }
                        }
                        Spacer()
                    }
                }
            }
            .sheet(isPresented: $showEditExpense){Text("Edit")}
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                            .font(Typography.headerM)
                    })
                    .accentColor(Palette.greyHard)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Last Events")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
            .onAppear{
                dataVM.getExpensesCoreData(filter: nil, storage: { storage in
                    dataVM.expenseFilteredList = storage
                })
            }
        }
    }
}

//struct LastEventsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        LastEventsListView()
//    }
//}

struct FilterButton: ButtonStyle {
    
    @Binding var isPressed : Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .padding(.horizontal,7)
            .font(Typography.ControlS)
            .background(isPressed ? Palette.black : Palette.greyLight)
            .foregroundColor(isPressed ? Palette.white : Palette.black)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}


struct FiltersRow: View {
    
    @State private var parkingIsPressed = false
    @State private var otherIsPressed = false
    @State private var finesIsPressed = false
    @State private var fuelIsPressed = false
    @State private var insuranceIsPressed = false
    @State private var tollsIsPressed = false
    @State private var maintenanceIsPressed = false
    @State private var roadTaxIsPressed = false
    
    @StateObject var dataVM : DataViewModel
    
    let fuelFilter = NSPredicate(format: "category == %@","0")
//    let maintFilter = NSPredicate(format: "category == %@","1")
    
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                
                Button("Fuel"){
                    impactMed.impactOccurred()
                    fuelIsPressed.toggle()
                    if(fuelIsPressed == true){
                        dataVM.getExpensesCoreData(filter: fuelFilter, storage: { storage in
                            dataVM.expenseFilteredList = storage
                        })
                    }
                    else {
                        dataVM.getExpensesCoreData(filter: nil, storage: { storage in
                            dataVM.expenseFilteredList = storage
                        })
                    }
                   
                }
                .buttonStyle(FilterButton(isPressed: $fuelIsPressed))
                
                Button("Tolls"){
                    impactMed.impactOccurred()
                    tollsIsPressed.toggle()
                }
                .buttonStyle(FilterButton(isPressed: $tollsIsPressed))
                
                Button("Maintenance"){
                    impactMed.impactOccurred()
                    maintenanceIsPressed.toggle()
                    if(maintenanceIsPressed == true){
                        dataVM.expenseFilteredList = dataVM.expenseList.filter {$0.category == 1 || $0.category == Category.fuel.rawValue}
                    }
                    else {
                        dataVM.expenseFilteredList = dataVM.expenseList
                    }
                        
                }
                .buttonStyle(FilterButton(isPressed: $maintenanceIsPressed))
                
                Button("Insurance"){
                    impactMed.impactOccurred()
                    insuranceIsPressed.toggle()
                }
                .buttonStyle(FilterButton(isPressed: $insuranceIsPressed))
                
                Button("Road Tax"){
                    impactMed.impactOccurred()
                    roadTaxIsPressed.toggle()
                }
                .buttonStyle(FilterButton(isPressed: $roadTaxIsPressed))
                
                Button("Fines"){
                    impactMed.impactOccurred()
                    finesIsPressed.toggle()
                }
                .buttonStyle(FilterButton(isPressed: $finesIsPressed))
                
                Button("Parking"){
                    impactMed.impactOccurred()
                    parkingIsPressed.toggle()
                }
                .buttonStyle(FilterButton(isPressed: $parkingIsPressed))
                
                Button("Other"){
                    impactMed.impactOccurred()
                    otherIsPressed.toggle()
                }
                .buttonStyle(FilterButton(isPressed: $otherIsPressed))
                
                
                
            }
            .padding(.leading)
            .padding(.top,25)
            .padding(.bottom,5)
        }
    }
}
