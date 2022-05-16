//
//  ImportantNumbersView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 14/05/22.
//

import SwiftUI

struct ImportantNumbersView: View {
    var body: some View {
        ZStack{
        VStack{
            HStack{
                Text("<")
                Text("Important numbers")
            }
            NumberCardView(title: "Service", number: "338293902")
            BlackButton(text: "Add new number")
        }
        }
        .background(Palette.colorViolet)
    }
}

struct NumberCardView: View {
    
    var title: String
    var number: String
    
    var body: some View {
        ZStack{
            Rectangle()
                .cornerRadius(12)
                .foregroundColor(Palette.greyBackground)
                .shadowGrey()
            HStack{
            VStack{
            Text(title)
            Text(number)
            }
            Spacer()
            HStack{
                
                Circle()
                Circle()
            }
            }
        }
        .frame(width: UIScreen.main.bounds.size.width * 0.84, height: UIScreen.main.bounds.size.height * 0.055, alignment: .center)
    }
}

struct ImportantNumbersView_Previews: PreviewProvider {
    static var previews: some View {
        ImportantNumbersView()
    }
}
