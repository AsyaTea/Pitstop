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
                            VStack(alignment: .trailing){
                                Text("10")
                                Spacer()
                                Text("8")
                                Spacer()
                                VStack{
                                    Text("6")
                                    Spacer()
                                }
                                Text("4")
                                Spacer()
                                Text("2")
                                Spacer()
                                Text("0")
                            }
                            .font(.subheadline)
                            .foregroundColor(Palette.greyMiddle)
                            FuelGraphView(data: sampleData)
                                .frame(height: 200)
                                .padding(.top, 25)
                                .padding(-15)
                        }
                        .padding(-15)
                        
                        HStack(alignment: .bottom) {
                            Text("Dec")
                            Spacer()
                            Text("Jan")
                            Spacer()
                            Text("Feb")
                            HStack{                                
                                Text("Mar")
                                Text("Apr")
                            }
                            Spacer()
                            Text("May")
                            Spacer()
                            Text("Jun")
                        }
                        .font(.subheadline)
                        .foregroundColor(Palette.greyMiddle)
                        
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
