//
//  AnalyticsFuelView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 12/05/22.
//

import SwiftUI

struct AnalyticsFuelView: View {
    var body: some View {
        
            
        VStack {            
            AnalyticsHeaderView()
                .frame(height: 30)
                .padding()
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
                                Text("9.5")
                                Text("9")
                                Text("8.5")
                                Text("8")
                                Text("7.5")
                            }
                           
                            .font(.subheadline)
                            .foregroundColor(Palette.greyMiddle)
                            FuelGraphView(data: sampleData)
                                .frame(height: 200)
                                .padding(.top, 25)
                                .padding(-10)
                        }
                        .padding(-15)
                        
                        HStack(alignment: .bottom) {
                            Text("Dec")
                            Text("Jan")
                            Text("Feb")
                            Text("Mar")
                            Text("Apr")
                            Text("May")
                            Text("Jun")
                        }
                        .font(.subheadline)
                        .foregroundColor(Palette.greyMiddle)
                        
                    }
                    
                    
                }
                
                Section {
                    FuelListView()
                        .padding(4)
                }
            }
        }
        .background(Palette.greyLight)
    }
    
}

struct AnalyticsFuelView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsFuelView()
    }
}
