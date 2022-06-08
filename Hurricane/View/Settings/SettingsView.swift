//
//  SettingsView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI


struct SettingsView: View {
    
    @ObservedObject var dataVM : DataViewModel
    @ObservedObject var homeVM : HomeViewModel
    @StateObject var onboardingVM: OnboardingViewModel
    
    //High priority function pepe
    var arrayColorBG = [Palette.colorGreen,Palette.colorYellow,Palette.colorViolet,Palette.colorBlue]
    var arrayColorCard = [Palette.colorMainGreen,Palette.colorMainYellow,Palette.colorMainViolet,Palette.colorMainBlue]
    @State var random = 0
    
    var body: some View {
        NavigationView{
            VStack{
                
                Link(destination: URL(string: "https://youtu.be/AZK4rSOw_PY")!){
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
                        }
                        //                                                .onDelete(perform: dataVM.deleteVehicle)
                        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        
                        Button(action: {
                            onboardingVM.addNewVehicle = true
                            onboardingVM.destination = .page2
                        }, label: {
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
                        })
                        
                        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        
                    }
                    Section{
                        HStack{
                            Button(action: {
                                random = Int.random(in: 0...3)
                                homeVM.headerBackgroundColor = arrayColorBG[random]
                                homeVM.headerCardColor = arrayColorCard[random]
                            }, label: {
                                Text("Theme")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.headerM)
                            })
                            Spacer()
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(homeVM.headerBackgroundColor)
                        }
                        
                        Text("About")
                            .foregroundColor(Palette.black)
                            .font(Typography.headerM)
                        
                    }
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                .listStyle(.insetGrouped)
                
                Spacer()
                
            }
            .fullScreenCover(isPresented: $onboardingVM.addNewVehicle){
                OnboardingView(onboardingVM: onboardingVM, dataVM: dataVM, shouldShowOnboarding: $onboardingVM.addNewVehicle)
            }
            .background(Palette.greyBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Text("Settings")
                    .foregroundColor(Palette.black)
                    .font(Typography.headerXL)
                
            )
        }
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


