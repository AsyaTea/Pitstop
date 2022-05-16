//
//  StatsView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//


import SwiftUI

struct AnalyticsOverviewView: View {
   
    @ObservedObject var categoryVM = CategoryViewModel()

    @State private var pickerTabs = ["Overview", "Cost", "Fuel", "Odometer"]
    @State var pickedTab = ""
    
    var body: some View {
        VStack{
            AnalyticsHeaderView()
            .frame(height: 30)
            .padding()
            
            List {
                CostsListView(categoryVM: categoryVM)
                Section {
                    FuelListView()
                        .padding(2)
                }
                Section {
                    OdometerCostsView()
                        .padding(2)
                }
            }
        }
        .overlay(content: {

        })
        .background(Palette.greyLight)
        
    }
    }


//MARK: Costs List Section
struct CostsListView: View {

    @ObservedObject var categoryVM : CategoryViewModel
    
    var body: some View {
    
            Section {
                HStack {
                    Text("Costs")
                        .font(Typography.headerL)
                    Spacer()
                    Text("$ 2089")
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
            
        ListCostsAttributes(title: "Category", value: "$ 20")
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Fuel", value: "$ 1.564")
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Refuels per month", value: "13")
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Average days/refuel", value: "26")
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
    }
}


//MARK: Odometer Section
struct OdometerCostsView: View {
    var body: some View {
        HStack {
            Text("Odometer")
                .font(Typography.headerL)
            Spacer()
            Text("2090 Km")
                .fontWeight(.semibold)
                .font(Typography.headerM)
        }
        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
        ListCostsAttributes(title: "Average", value: "25.4 km/day")
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Month Total", value: "678 km")
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
    
    var body: some View {
        HStack{
            HStack {
                Text("Analytics")
                    .fontWeight(.bold)
                    .font(Typography.headerXL)
            }
            .frame(alignment: .topLeading)
            .padding()
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
                            Text("Per month")
                                .foregroundColor(Palette.black)
                                .font(Typography.ControlS)
                            Image("arrowDown")
                            
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
            }
            .padding(.top,2)
        }
    }
}


    

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsOverviewView()
    }
}
