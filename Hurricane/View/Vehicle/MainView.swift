//
//  MainView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import SwiftUI

struct MainView: View {
    
    @State private var showingSheet = false
    
    var body: some View {
        ZStack{
            Palette.greyBackground
            ContentView3()
            
        }
        .overlay(
            VStack{
                Spacer(minLength: UIScreen.main.bounds.size.height * 0.77)
                Button(action: {
                    showingSheet.toggle()
                }, label: {
                    AddReportButton(text: "Add report")
                })
                Spacer()
            }
        )
        .sheet(isPresented: $showingSheet) {
                   AddReportView()
               }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct StatView: View {
    var body: some View {
        ForEach(0..<3) { _ in
            HStack {
                ZStack{
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 108, height: 76, alignment: .center)
                        .foregroundColor(Palette.colorVioletLight)
                    VStack{
                        Text("$23,4")
                            .font(Typography.headerL)
                            .foregroundColor(Palette.black)
                        Text("All costs")
                            .font(Typography.TextM)
                            .foregroundColor(Palette.black)
                    }
                    .foregroundColor(.black)
                    
                }
            }
        }
        
        
    }
}

struct AddReportButton : View {
    
    var text : String
    var body: some View {
        
        ZStack{
            Rectangle()
                .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055, alignment: .center)
                .cornerRadius(43)
                .foregroundColor(Palette.black)
            HStack{
                Spacer()
                Image("plus")
                    .resizable()
                    .frame(width: 14, height: 14)
                Text(text)
                    .foregroundColor(Palette.white)
                    .font(Typography.ControlS)
                Spacer()
            }
        }
    }
}



