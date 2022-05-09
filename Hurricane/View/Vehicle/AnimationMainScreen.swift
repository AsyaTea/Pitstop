//
//  AnimationMainScreen.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import SwiftUI

struct AnimationMainScreen: View {
    
    @State var witdh : CGFloat = 0
    
    var body: some View {
        
            GeometryReader{ geo in
        HStack{
           
            Rectangle()
                .frame(width: geo.size.width, height: geo.size.height)
                .foregroundColor(Palette.colorViolet)
                .onTapGesture {
                    witdh -= 20
                }
            Rectangle()
                .frame(width: geo.size.width, height: geo.size.height/3)
                .foregroundColor(.orange)
                .rotation3DEffect(Angle(degrees: Double(geo.frame(in: .global).minX-witdh)/4), axis: (x:10,y:1,z:0))
            }
        }.ignoresSafeArea()
        }
}

struct AnimationMainScreen_Previews: PreviewProvider {
    static var previews: some View {
        AnimationMainScreen()
    }
}
