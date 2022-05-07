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
            Text("Go away \n we are working!")
                .multilineTextAlignment(.center)
                .font(Typography.headerXXL)
        Image("bestBoy")
                .resizable()
                .scaledToFit()
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
