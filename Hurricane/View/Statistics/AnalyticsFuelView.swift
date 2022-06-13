//
//  AnalyticsFuelView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 12/05/22.
//

import SwiftUI

struct AnalyticsFuelView: View {
    @ObservedObject var categoryVM : CategoryViewModel
    @ObservedObject var utilityVM : UtilityViewModel
    var body: some View {
        
            
        VStack {            
            
            List {                
                Section {
                    VStack{
                        HStack {
                            VStack(alignment: .leading){
                                Spacer()
                                Text("8.71 L/100km")
                                    .font(Typography.headerL)
                                    .padding(1)
                                Text("Efficiency")
                                    .foregroundColor(Palette.greyHard)
                            }
                            Spacer()
                            Text(" ▼ 12 % ")
                                .font(Typography.headerS)
                                .foregroundColor(Palette.greenHighlight)
                        }
                        .padding(-3)
                        HStack{
                            FuelGraphView(categoryVM: categoryVM, data: categoryVM.fuelGraphData)
                                .frame(height: 200)
                                .padding(.top, 25)
                                .padding(1)
                        }
                        .padding(-15)
                     
//                        HStack(alignment: .bottom) {
//                            
//                    
//                                Text("Jan")
//                      
//
//                            Spacer()
//                            Text("Mar")
//                        
//                                Spacer()
//                                Text("May")
//                                Spacer()
//                                Text("Jun")
//                     
//                            
//                    }
//                        .padding(-15)
//                    .font(.subheadline)
//                    .foregroundColor(Palette.greyMiddle)
                Spacer()
                        
                    }
                    
                    
                }
                
                Section {
                    FuelListView(categoryVM: categoryVM, utilityVM: utilityVM)
                        .padding(4)
                }
            }
        }
        .background(Palette.greyLight)
    }
    
}

struct AnalyticsFuelView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsFuelView(categoryVM: CategoryViewModel(), utilityVM: UtilityViewModel())
    }
}
