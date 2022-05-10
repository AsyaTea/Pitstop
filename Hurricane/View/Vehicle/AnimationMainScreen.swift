//
//  AnimationMainScreen.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import SwiftUI

struct Tab : Identifiable {
    var id = UUID().uuidString
    var tab : String
    var vehicle : [VehicleModel]
}

var tabItems = [
    Tab(tab: "Last activities", vehicle: vehicleSample.shuffled()),
    Tab(tab: "Documents", vehicle: vehicleSample.shuffled()),
    Tab(tab: "Numbers", vehicle: vehicleSample.shuffled())
    
]

var vehicleSample = [
    VehicleModel(brand: "Toyota", document: Data(), fuelType:0, model: "Yaris", name: "My Car 1", odometer: 29300, plate: "N3829IDJ", vehicleID: UUID(), year: 2010),
    VehicleModel(brand: "Volvo", document: Data(), fuelType:0, model: "DrumNBass", name: "My Car 2", odometer: 29300, plate: "N3829IDJ", vehicleID: UUID(), year: 2010),
    VehicleModel(brand: "Fiat", document: Data(), fuelType:0, model: "Crotone", name: "My Car 3", odometer: 29300, plate: "N3829IDJ", vehicleID: UUID(), year: 2010),
    VehicleModel(brand: "Ape", document: Data(), fuelType:0, model: "Carro", name: "My Car 4", odometer: 29300, plate: "N3829IDJ", vehicleID: UUID(), year: 2010)
    
]

struct AnimationMainScreen: View {
    
    @State var offset : CGFloat = 0
    
    var body: some View {
        
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 15, pinnedViews: [.sectionHeaders], content: {
                
                //Parallax
                GeometryReader{ reader ->AnyView in
                    
                    let offset = reader.frame(in: .global).minY
                    
                    if -offset >= 0 {
                        DispatchQueue.main.async {
                            self.offset = offset
                        }
                    }
                    
                    return AnyView(
                        Image("page1")
                            .resizable()
                            .aspectRatio(contentMode:.fill)
                            .frame(width:UIScreen.main.bounds.width,height:250 + (offset > 0 ? offset: 0))
                            .offset(y: (offset > 0 ? -offset : 0))
                            .cornerRadius(2)
                    )
                }.frame(height:250)
                
                Section(header:Text("Header").font(Typography.headerXL)){
                    ForEach(tabItems){ tab in
                        VStack(alignment: .leading, spacing: 15,content: {
                            Text(tab.tab)
                                .font(Typography.headerM)
                            ForEach (tab.vehicle, id: \.self){ vehicle in
                                
                                Text(vehicle.name ?? "")
                                
                            }
                        })
                    }
                }
            })
        }.overlay(
            Color.white
                .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top,alignment: .top)
                .ignoresSafeArea(.all,edges:.top)
                .opacity(offset > 250 ? 1 : 0)
            ,alignment: .top
        )
    }
}

struct AnimationMainScreen_Previews: PreviewProvider {
    static var previews: some View {
        AnimationMainScreen()
    }
}
