//
//  ContentView3.swift
//  Hurricane
//
//  Created by Asya Tealdi on 06/05/22.
//

import SwiftUI

struct ContentView3: View {
    var body: some View {
        ZStack{
            Palette.greyBackground
            VStack {
                        VStack {
                            HStack {
                                //Title
                                Text("Barman's Car >")
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                    .font(.title)
                                Spacer()
                                //Per month Button
                                Button {
                                    print("Button is tapped")
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 50)
                                            .foregroundColor(.blue)
                                        Text("Per month")
                                            .font(.system(size: 12))
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 80, height: 25, alignment: .center)
                                }
                                //Bell ring button
                                Button {
                                    print("Bell is tapped")
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 100)
                                            .frame(width: 25, height: 25, alignment: .center)
                                        Image(systemName: "bell")
                                            .foregroundColor(.white)
                                            .font(.subheadline)
                                            
                                        
                                        
                                    }
                                }
                            }
                            .font(.title)
                            
                            //Model text
                            HStack{
                                Text("Range Rover Evoque, 2017")
                                Spacer()
                            }
                            Spacer()
                        }
                        .padding(25)
                        .frame(width: 430, height: 100, alignment: .topLeading)
                        
                        //Stats views
                        HStack {
                            ForEach(0..<3) { _ in
                                StatView()
                            }
                        }
                        Spacer()
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

struct ContentView3_Previews: PreviewProvider {
    static var previews: some View {
        ContentView3()
    }
}
