//
//  StatsCostView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 12/05/22.
//

import SwiftUI

struct AnalyticsCostView: View {
    var body: some View {
        
            VStack{
                AnalyticsHeaderView()
                .frame(height: 30)
                .padding()
                
                List {
                    Section {
                        
                    }
                    
                    Section {
                        CostsListView()
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

struct AnalyticsCostView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsCostView()
    }
}
