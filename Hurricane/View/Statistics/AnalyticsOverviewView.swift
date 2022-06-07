//
//  StatsView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//


import SwiftUI

struct AnalyticsOverviewView: View {
       
    @StateObject var statisticsVM = StatisticsViewModel()
    @ObservedObject var dataVM : DataViewModel
    @ObservedObject var categoryVM : CategoryViewModel
    @ObservedObject var utilityVM : UtilityViewModel

    @State private var pickerTabs = ["Overview", "Cost", "Fuel", "Odometer"]
    @State var pickedTab = ""
    
    @Namespace var animation
    
//    init() {
//        //  Change list background color
//        UITableView.appearance().separatorStyle = .singleLine
//        UITableView.appearance().backgroundColor = UIColor(Palette.greyBackground)
//        UITableView.appearance().separatorColor = UIColor(Palette.greyLight)
//    }
    
    var body: some View {
       
        VStack{
            AnalyticsHeaderView(statisticsVM: statisticsVM, categoryVM: categoryVM, dataVM: dataVM)
            .frame(height: 30)
            
            if categoryVM.expenseList.isEmpty {
                ZStack{
                    Palette.greyBackground.ignoresSafeArea()
                    ProgressView()
                }
               
            }
            
            if(categoryVM.currentPickerTab == "Overview") {
                OverviewView(dataVM: dataVM, categoryVM: categoryVM, utilityVM: utilityVM)
            }
            else if (categoryVM.currentPickerTab == "Cost") {
                AnalyticsCostView(categoryVM: categoryVM, dataVM: dataVM, utilityVM: utilityVM)
            }
            else if (categoryVM.currentPickerTab == "Fuel") {
                AnalyticsFuelView(categoryVM: categoryVM)
            }
            else {
                AnalyticsOdometerView(categoryVM: categoryVM, dataVM: dataVM)
            }
            
            
            
        }
        .background(Palette.greyBackground)
        .overlay(content: {
            VStack{
                Spacer()
                CustomSegmentedPicker()
                    
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    
            }
        })
        .background(Palette.greyLight)
   }
    
    
    func CustomSegmentedPicker() -> some View{
        ZStack {
        HStack(alignment: .center, spacing:10){
                ForEach(pickerTabs,id:\.self){ tab in
                    if categoryVM.currentPickerTab == tab {
                    Text(tab)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .font(Typography.headerS)
                        .foregroundColor(Palette.white)
                        .background {
                            if categoryVM.currentPickerTab == tab {
                                Capsule()
                                    .fill(Palette.black)
                                    .matchedGeometryEffect(id: "pickerTab", in: animation)
                            }
                        }
                        .containerShape(Capsule())
                        .contentShape(Capsule())
                        .onTapGesture {
                            withAnimation(.easeInOut){
                                categoryVM.currentPickerTab = tab
                                let haptic = UIImpactFeedbackGenerator(style: .soft)
                                haptic.impactOccurred()
                            }
                        }
                    } else {
                    Text(tab)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .font(Typography.headerS)
                        .foregroundColor(Palette.black)
                        .background {
                            if categoryVM.currentPickerTab == tab {
                                Capsule()
                                    .fill(Palette.black)
                                    .matchedGeometryEffect(id: "pickerTab", in: animation)
                            }
                        }
                        .containerShape(Capsule())
                        .contentShape(Capsule())
                        .onTapGesture {
                            withAnimation(.easeInOut){
                                categoryVM.currentPickerTab = tab
                                let haptic = UIImpactFeedbackGenerator(style: .soft)
                                haptic.impactOccurred()
                            }
                        }
                }
            }
        }
        .padding(.horizontal, 3)
        }
    }
}

//MARK: Overview page
struct OverviewView: View {
    @ObservedObject var dataVM : DataViewModel
    @ObservedObject var categoryVM : CategoryViewModel
    @ObservedObject var utilityVM : UtilityViewModel
    var body: some View {
        List {
            CostsListView(utilityVM:utilityVM, categoryVM: categoryVM, dataVM: dataVM)
            Section {
                FuelListView(categoryVM: categoryVM)
                    .padding(2)
            }
            Section {
                OdometerCostsView(categoryVM: categoryVM, dataVM: dataVM)
                    .padding(2)
            }
        }        
    }
}


//MARK: Costs List Section
struct CostsListView: View {

    @ObservedObject var utilityVM : UtilityViewModel
    @ObservedObject var categoryVM : CategoryViewModel
    @ObservedObject var dataVM : DataViewModel
    
    var body: some View {
    
            Section {
                HStack {
                    Text("Costs")
                        .font(Typography.headerL)
                    Spacer()
                    let formattedCost = String(format: "%.0f", dataVM.totalExpense)
                    Text("\(formattedCost) \(utilityVM.currency)")
                        .fontWeight(.semibold)
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
               
                ForEach(categoryVM.categories, id: \.self) { category in
                    HStack{
                        ListCategoryComponent(title: category.name, iconName: category.icon, color: category.color)
                        Spacer()
                        Text(String(category.totalCosts))
                            .font(Typography.headerM)
                            .foregroundColor(Palette.greyHard)
                    }
                    .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                }
            }
            
            .padding(2)
    }
}

//MARK: Fuel data Section
struct FuelListView : View {
    @ObservedObject var categoryVM : CategoryViewModel
    var body: some View {
        
        HStack {
            Text("Fuel")
                .font(Typography.headerL)
            Spacer()
            Text("8,71L/100 Km")
                .fontWeight(.semibold)
                .font(Typography.headerM)
        }
        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
        ListCostsAttributes(title: "Category", value: String(categoryVM.fuelTotal))
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Average price", value: String(categoryVM.avgPrice))
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Refuels", value: String(categoryVM.refuelsPerTime))
           
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Average days/refuel", value: String(categoryVM.avgDaysRefuel))
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
    }
}


//MARK: Odometer Section
struct OdometerCostsView: View {
    @ObservedObject var categoryVM : CategoryViewModel
    @ObservedObject var dataVM : DataViewModel
    var body: some View {
        HStack {
            Text("Odometer")
                .font(Typography.headerL)
            Spacer()
            Text("\(String(Int(dataVM.currentVehicle.first?.odometer ?? 0))) Km")
                .fontWeight(.semibold)
                .font(Typography.headerM)
        }
        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
        ListCostsAttributes(title: "Average", value: "25.4 km/day")
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Month Total", value: String(categoryVM.odometerTotal))
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Estimated km/year", value: "9262 km")
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
       

    }
}

//MARK: List row
struct ListCostsAttributes: View {
    var title : String
    var value : String
    var body: some View {
        HStack{
            Text(title)
                .font(Typography.headerM)
            Spacer()
            Text(value)
                .foregroundColor(Palette.greyHard)
        }
        
    }
}

//MARK: Analytics Header 

struct AnalyticsHeaderView : View {
    @ObservedObject var statisticsVM : StatisticsViewModel
    @ObservedObject var categoryVM : CategoryViewModel
    @ObservedObject var dataVM : DataViewModel
    @State private var selectedTimeFrame = "Per month"
    var body: some View {
        HStack{
            HStack {
                Text("Analytics")                    
                    .font(Typography.headerXL)
                    .padding(.leading,20)
            }
            .frame(alignment: .topLeading)
            
            Spacer()
            
            HStack{
                Button(action: {
                    
                }, label: {
                    ZStack{
                        Rectangle()
                            .foregroundColor(Palette.white)
                            .cornerRadius(37)
                            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.04)
                            .shadowGrey()
                        HStack{
                            Menu {
                                Picker(selection: $selectedTimeFrame, label: Text("Time")) {
                                    ForEach(categoryVM.timeFrames, id: \.self) { time in
                                        Text(time).tag(time)
                                    }
                                        }
                                        .onChange(of: selectedTimeFrame) { tag in                                        
                                            categoryVM.setSelectedTimeFrame(timeFrame: tag)
                                            print("tag is  \(tag)")
                                        }
                                
                            } label: {
                                HStack {
                                    Text(categoryVM.selectedTimeFrame)
                                        .foregroundColor(Palette.black)
                                        .font(Typography.ControlS)
                                    Image("arrowDown")
                                }
                            }
                            
                            
                        }
                    
                    }
                })
               
                ZStack{
                    Button(action: {
                        
                        
                    }, label: {
                        ZStack{
                            Circle()
                                .foregroundColor(Palette.white)
                                .frame(width: UIScreen.main.bounds.width * 0.09, height: UIScreen.main.bounds.height * 0.04)
                                .shadowGrey()
                            Image("download")
                        }
                    })
                }
                .padding()
            }
            .padding(.top,2)
        }
        .padding(.top)
    }
}


    
//
//struct StatsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnalyticsOverviewView(dataVM: DataViewModel(), utilityVM: UtilityViewModel())
//    }
//}
