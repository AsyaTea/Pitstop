//
//  MainView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        ZStack{
            Palette.greyBackground
            VStack{
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
            
        }
        .overlay(
            VStack{
                Spacer(minLength: UIScreen.main.bounds.size.height * 0.77)
                Button(action: {
                    
                    //       vehicleVM.addExpense(expense: expense)
                    //       vehicleVM.getExpenses()
                }, label: {
                    addButtonView()
                })
                Spacer()
            }
            //                    .padding(.top,50)
        )
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct addButtonView : View {
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: 343, height: 48, alignment: .center)
                .cornerRadius(43)
                .foregroundColor(Palette.black)
            HStack{
                Spacer()
                Image("plus")
                    .resizable()
                    .frame(width: 14, height: 14)
                Text("Add expense")
                    .foregroundColor(Palette.white)
                    .font(Typography.ControlS)
                Spacer()
            }
        }
    }
}
