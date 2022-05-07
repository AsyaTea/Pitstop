//
//  SettingsView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct SettingsView: View {
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
