//
//  StatsView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct StatsView: View {
    var body: some View {
        VStack{
            HStack{
            
                //Header
                
                HStack {
                    Text("Analytics")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .frame(alignment: .topLeading)
                .padding()
                
                Spacer()
                
                ZStack{
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(.white)
                    Text("Per month")
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                }
                .frame(width: 80, height: 25, alignment: .center)
                //List
                }
                
                
                Spacer()
            
            
//            Text("Go away \n we are working!")
//                .multilineTextAlignment(.center)
//                .font(Typography.headerXXL)
//        Image("bestBoy")
//                .resizable()
//                .scaledToFit()
            
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
