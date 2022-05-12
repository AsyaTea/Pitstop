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
                        HStack{
                            VStack(alignment: .trailing){
                                Text("10")
                                Spacer()
                                VStack{
                                    Spacer()
                                    Text("9.5")
                                    Spacer()
                                    Text("9")
                                    Spacer()
                                    Text("8.5")
                                    Spacer()
                                    Text("8")
                                    Spacer()
                                }
                                Spacer()
                                Text("7.5")
                              
                            }
                            .font(.subheadline)
                            .foregroundColor(Palette.greyMiddle)
                            .padding(.vertical)
                            
                            .foregroundColor(Palette.greyHard)
                            
                            GraphPractice()
                        }
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
                        .padding(.horizontal)
                    }
                    
                }
//                .frame(width: 350, height: 300)
                
                Section {
                    FuelListView()
                        .padding(2)
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
