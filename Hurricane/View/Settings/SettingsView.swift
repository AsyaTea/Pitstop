//
//  SettingsView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI


struct SettingsView: View {
    
    @ObservedObject var dataVM : DataViewModel
    
    var body: some View {
        NavigationView{
            VStack{
                
                Link(destination: URL(string: "https://youtu.be/y9DzkqJ1Fu8")!){
                    PremiumBanner()
                        .padding(.top,20)
                }
                List{
                    Section{
                        ForEach(dataVM.vehicleList,id:\.self){ vehicle in
                            NavigationLink(destination: EditVehicleView(dataVM: dataVM, vehicle: vehicle, vehicleS: VehicleState.fromVehicleViewModel(vm: vehicle))){
                                Text(vehicle.name)
                                    .font(Typography.headerM)
                                    .foregroundColor(Palette.black)
                            }
                        }.onDelete(perform: dataVM.deleteVehicle)
                        
                        NavigationLink(destination: AddNewVehicle()){
                            HStack{
                                ZStack{
                                    Circle()
                                        .foregroundColor(Palette.greyBackground)
                                        .frame(width: 32, height: 32)
                                    Image("plus")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(Palette.black)
                                    
                                }
                                Text("Add car")
                                    .font(Typography.headerM)
                                    .foregroundColor(Palette.black)
                            }
                        }
                        
                    }
                    Section{
                        Text("Currency")
                        Text("Unit")
                        Text("Theme")
                    }
                    
                    Section{
                        Text("Widget")
                        Text("Widget")
                        Text("Widget")
                    }
                }.listStyle(.insetGrouped)
                
                Spacer()
                
            }
            .background(Palette.greyBackground)
            //            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Text("Settings")
                    .foregroundColor(Palette.black)
                    .font(Typography.headerXL)
                
            )
        }
        //        .task{
        //            dataVM.getVehiclesCoreData(filter: nil, storage: {storage in
        //                dataVM.vehicleList = storage
        //                print("successsss")
        //
        //            })
        //        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditCarView()
//    }
//}

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
                    Text("Let us remind you key dates \nabout your vehicles")
                        .font(Typography.TextM)
                        .foregroundColor(Palette.white)
                        .padding(.top,-8)
                        .multilineTextAlignment(.leading)
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


