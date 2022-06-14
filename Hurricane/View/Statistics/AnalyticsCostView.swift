//
//  StatsCostView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 12/05/22.
//

import SwiftUI

struct AnalyticsCostView: View {
    @ObservedObject var categoryVM : CategoryViewModel
    @ObservedObject var dataVM : DataViewModel
    @ObservedObject var utilityVM : UtilityViewModel
    var body: some View {
        
            VStack{
                List {
                    Section {
                        CostGraphView(utilityVM: utilityVM, categoryVM: categoryVM, dataVM: dataVM)
                            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                            .frame(height: 201)
                    }
                    Section {
                        CostsListView(utilityVM: utilityVM, categoryVM: categoryVM, dataVM: dataVM)
                    }
                    Section {                        
                    }
                }
            }
            .overlay(content: {

            })
            .background(Palette.greyLight)
        
    }
}
    
struct CostGraphView : View {
    @ObservedObject var utilityVM : UtilityViewModel
    @ObservedObject var categoryVM : CategoryViewModel
    @ObservedObject var dataVM : DataViewModel
    var value = "50%"
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading){
                    
                    let formattedCost = String(format: "%.0f", dataVM.totalExpense)
                    Text("\(formattedCost) \(utilityVM.currency)")
                        .font(Typography.headerL)
                        .padding(1)
                    Text("Cost structure")
                        .foregroundColor(Palette.greyHard)
                    
                }
                
                Spacer()
//                Text(" ▼ 12 % ")
//                    .font(Typography.headerS)
//                    .foregroundColor(Palette.greenHighlight)
            }
            
            Spacer()
            
            //GRAPH LINE
//            RoundedRectangle(cornerRadius: 5)
//                .frame(width: 340, height: 20, alignment: .bottom)
            LineGraph(categoryVM: categoryVM)
            
            
            Spacer()
           
            //LABELS
            VStack{
                
                    VStack{
                        HStack{
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 16, height: 16, alignment: .topLeading)
                            .foregroundColor(Palette.colorYellow)
                        Text("Fuel  ")
                            let formattedPerc = String(format: "%.0f", categoryVM.fuelPercentage)
                            Text("\(formattedPerc) %")
//                            Text(String(categoryVM.fuelPercentage))
                            .foregroundColor(Palette.greyHard)
                            
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 16, height: 16, alignment: .topLeading)
                            .foregroundColor(Palette.colorOrange)
                        Text("Taxes")
                            let formattedTaxesPerc = String(format: "%.0f", categoryVM.taxesPercentage)
                            Text("\(formattedTaxesPerc) %")
                            .foregroundColor(Palette.greyHard)
                            Spacer()
                        }
                        }
                    
                    VStack{
                        HStack {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 16, height: 16, alignment: .topLeading)
                            .foregroundColor(Palette.colorViolet)
                        Text("Other")
                            let formattedOtherPerc = String(format: "%.0f", categoryVM.otherPercentage)
                            Text("\(formattedOtherPerc) %")
                            .foregroundColor(Palette.greyHard)
                            
                            
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 16, height: 16, alignment: .center)
                            .foregroundColor(Palette.colorGreen)
                        Text("Maintainance")
                            let formattedMainPerc = String(format: "%.0f", categoryVM.maintainancePercentage)
                            Text("\(formattedMainPerc) %")
                            .foregroundColor(Palette.greyHard)
                            Spacer()
                            }
                            
                        
                        
                    }
                }
                .padding(.leading,5)
                Spacer()
            
            
        }
        
    }
}

struct LineGraph: View {
    @ObservedObject var categoryVM : CategoryViewModel

        var body: some View {
            VStack(alignment: .leading) {
                cell()
            }
        }

        @ViewBuilder
        func cell() -> some View {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 340, height: 20, alignment: .bottom)
                .foregroundColor(.white)
                .overlay(content: {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            HStack{
                                Rectangle()
                                    .foregroundColor(Palette.colorYellow)
                                    .frame(width: geometry.size.width * CGFloat(categoryVM.fuelPercentage / 100), height: geometry.size.height)
                                    .padding(-5)
                                Rectangle()
                                    .foregroundColor(Palette.colorOrange)
                                    .frame(width: geometry.size.width * CGFloat(categoryVM.taxesPercentage / 100), height: geometry.size.height)
                                    .padding(-2)
                                Rectangle()
                                    .foregroundColor(Palette.colorViolet)
                                    .frame(width: geometry.size.width * CGFloat(categoryVM.otherPercentage / 100), height: geometry.size.height)
                                    .padding(-5)
                                Rectangle()
                                    .foregroundColor(Palette.colorGreen)
                                    .frame(width: geometry.size.width * CGFloat(categoryVM.maintainancePercentage / 100), height: geometry.size.height)
                                    .padding(-2)
                                    
                            }
                            
                        }
                    }
                })
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    
}

struct AnalyticsCostView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsCostView(categoryVM: CategoryViewModel(), dataVM: DataViewModel(), utilityVM: UtilityViewModel())
    }
}
