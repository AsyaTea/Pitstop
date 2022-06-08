//
//  HeaderView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/05/22.
//

import SwiftUI

struct HeaderContent : View {
    @Binding var offset: CGFloat
    var maxHeight : CGFloat
    
    @ObservedObject var dataVM : DataViewModel
    @ObservedObject var homeVM: HomeViewModel
    @ObservedObject var utilityVM : UtilityViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            HStack(spacing:13){
                
                Button(action: {
                    
                }, label: {
                    ZStack{
                        Rectangle()
                            .cornerRadius(16)
                            .foregroundColor(homeVM.headerCardColor)
                            .frame(width: UIScreen.main.bounds.width * 0.29, height: UIScreen.main.bounds.height * 0.09)
                        VStack(alignment: .center){
                            let formattedCost = String(format: "%.0f", dataVM.totalExpense)
                            Text("\(formattedCost) \(utilityVM.currency)")
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.headerL)
                            Text("All costs")
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.TextM)
                        }
                    }
                })
                
                Button(action: {
                    
                }, label: {
                    ZStack{
                        Rectangle()
                            .cornerRadius(16)
                            .foregroundColor(homeVM.headerCardColor)
                            .frame(width: UIScreen.main.bounds.width * 0.29, height: UIScreen.main.bounds.height * 0.09)
                        VStack(alignment: .center){
                            Text(String(Int64(dataVM.currentVehicle.first?.odometer ?? 0)))
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.headerL)
                            Text("Odometer")
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.TextM)
                        }
                    }
                })
                
                Button(action: {
                    
                }, label: {
                    ZStack{
                        Rectangle()
                            .cornerRadius(16)
                            .foregroundColor(homeVM.headerCardColor)
                            .frame(width: UIScreen.main.bounds.width * 0.29, height: UIScreen.main.bounds.height * 0.09)
                        VStack(alignment: .center){
                            Text("*** $")
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.headerL)
                            Text("Coming Soon")
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.TextM)
                        }
                    }
                })
            }
        }
        .padding()
        .padding(.bottom)
    }
}
