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
        ZStack{
            RoundedRectangle(cornerRadius: 35)
                .frame(width: 120, height: 95, alignment: .center)
                .foregroundColor(Palette.colorVioletLight)
            VStack{
                Text("$23,4")
                Text("All costs")
            }
            .foregroundColor(.black)
            
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



