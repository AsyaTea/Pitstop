//
//  WorkInProgress.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//

import SwiftUI

struct WorkInProgress: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
        Image("bestBoy")
            .resizable()
            .scaledToFit()
        Text("Go away we are working!")
            .font(Typography.headerXL)
            Spacer()
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Go back")
                    .font(Typography.headerL)
            })
            Spacer()
        }
    }
}

struct WorkInProgress_Previews: PreviewProvider {
    static var previews: some View {
        WorkInProgress()
    }
}
