//
//  SettingsView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct SettingsView: View {
    
    init() {
        //  Change list background color
        UITableView.appearance().separatorStyle = .singleLine
        UITableView.appearance().backgroundColor = UIColor(Palette.greyBackground)
        UITableView.appearance().separatorColor = UIColor(Palette.greyLight)
    }
    
    @StateObject var dataVM = DataViewModel()
    
    var body: some View {
        VStack{
            
            HStack{
                
            Text("Settings")
                .font(Typography.headerXL)
                .padding(.leading,15)
                Spacer()
            }
            Link(destination: URL(string: "https://youtu.be/y9DzkqJ1Fu8")!){
            PremiumBanner()
                .padding(.top,5)
            }
            List{
                Section{
                    ForEach(dataVM.vehicles){ vehicle in
                        Text(vehicle.name ?? "")
                            .font(Typography.headerM)
                            .foregroundColor(Palette.black)
                    }
                    Text("Add car")
                }
                Section{
                    Text("Barman's car")
                    Text("Barman's car")
                    Text("Barman's car")
                }
                
                Section{
                    Text("Widget")
                    Text("Widget")
                    Text("Widget")
                }
            }
            
            Spacer()
            
        }
        .background(Palette.greyBackground)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct PremiumBanner : View {
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.accentColor)
                .cornerRadius(15)
                .frame(width: UIScreen.main.bounds.width * 0.93, height: UIScreen.main.bounds.width * 0.4)
            HStack{
                VStack(alignment: .leading){
                    Text("Get more features")
                        .font(Typography.headerL)
                        .foregroundColor(Palette.white)
                    Text("Unlock the settings and the statistics")
                        .font(Typography.TextM)
                        .foregroundColor(Palette.white)
                        .padding(.top,-8)
                    ZStack{
                        Rectangle()
                            .cornerRadius(8)
                            .foregroundColor(Palette.white)
                            .frame(width: 100, height: 32)
                        Text("Go premium")
                            .foregroundColor(Palette.black)
                            .font(Typography.ControlS)
                    }.padding(.top,10)
                    
                }.padding(.leading)
                Image("premium")
            }
        }
    }
}
