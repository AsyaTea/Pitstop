//
//  SettingsView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var homeVM: HomeViewModel
    @StateObject var onboardingVM: OnboardingViewModel
    @ObservedObject var categoryVM: CategoryViewModel

    // High priority function pepe
    //    var arrayColorBG = [Palette.colorGreen,Palette.colorYellow,Palette.colorViolet,Palette.colorBlue]
    //    var arrayColorCard = [Palette.colorMainGreen,Palette.colorMainYellow,Palette.colorMainViolet,Palette.colorMainBlue]
    //    @State var random = 0

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                PremiumBanner()
                    .padding(.top, 20)
                List {
                    Section(header: Text("Vehicles")) {
                        ForEach(dataVM.vehicleList, id: \.self) { vehicle in
                            NavigationLink(destination: EditVehicleView(dataVM: dataVM, vehicle: vehicle, vehicleS: VehicleState.fromVehicleViewModel(vm: vehicle))) {
                                Text(vehicle.name)
                                    .font(Typography.headerM)
                                    .foregroundColor(Palette.black)
                            }
                        }
                        //                                                .onDelete(perform: dataVM.deleteVehicle)
                        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

                        // MARK: - ADD NEW VEHICLE

                        Button(action: {
                            onboardingVM.addNewVehicle = true
                            onboardingVM.destination = .page2
                        }, label: {
                            HStack {
                                ZStack {
                                    Circle()
                                        .foregroundColor(Palette.greyBackground)
                                        .frame(width: 32, height: 32)
                                    Image("plus")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(Palette.black)
                                }
                                Text("Add vehicle")
                                    .font(Typography.headerM)
                                    .foregroundColor(Palette.black)
                            }
                        })

                        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                    }
                    Section(header: Text("Other")) {
                        //                        HStack{
                        //                            Button(action: {
                        //                                random = Int.random(in: 0...3)
                        //                                homeVM.headerBackgroundColor = arrayColorBG[random]
                        //                                homeVM.headerCardColor = arrayColorCard[random]
                        //                            }, label: {
                        //                                Text("Theme")
                        //                                    .foregroundColor(Palette.black)
                        //                                    .font(Typography.headerM)
                        //                            })
                        //                            Spacer()
                        //                            Circle()
                        //                                .frame(width: 20, height: 20)
                        //                                .foregroundColor(homeVM.headerBackgroundColor)
                        //                        }

                        NavigationLink(destination: ThemePickerView(homeVM: homeVM)) {
                            Text("Theme")
                                .foregroundColor(Palette.black)
                                .font(Typography.headerM)
                        }

                        NavigationLink(destination: AboutView()) {
                            Text("About us")
                                .foregroundColor(Palette.black)
                                .font(Typography.headerM)
                        }

                        NavigationLink(destination: ToSView()) {
                            Text("Terms of Service")
                                .foregroundColor(Palette.black)
                                .font(Typography.headerM)
                        }
                    }
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                .listStyle(.insetGrouped)

                Spacer()
            }
            .fullScreenCover(isPresented: $onboardingVM.addNewVehicle) {
                OnboardingView(onboardingVM: onboardingVM, dataVM: dataVM, categoryVM: categoryVM, shouldShowOnboarding: $onboardingVM.addNewVehicle)
            }
            .background(Palette.greyBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                Text("Settings")
                    .foregroundColor(Palette.black)
                    .font(Typography.headerXL)
                    .padding(.top, 15)
            )
        }
    }
}

// struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditCarView()
//    }
// }

struct PremiumBanner: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.accentColor)
                .cornerRadius(15)
                .frame(width: UIScreen.main.bounds.width * 0.915, height: UIScreen.main.bounds.height * 0.235 - 50)
            HStack {
                VStack(alignment: .leading) {
                    Text("Get more features")
                        .font(Typography.headerL)
                        .foregroundColor(Palette.white)
                    Text("Add more features to better \nmanage your vehicles")
                        .font(Typography.TextM)
                        .foregroundColor(Palette.white)
                        .padding(.top, -8)
                        .multilineTextAlignment(.leading)
                    ZStack {
                        Rectangle()
                            .cornerRadius(8)
                            .foregroundColor(Palette.white)
                            .frame(width: 100, height: 32)
                        Text("Coming soon")
                            .foregroundColor(Palette.black)
                            .font(Typography.ControlS)
                    }.padding(.top, 10)

                }.padding()
                Image("premium")
            }
            .padding(8)
        }
    }
}

struct ToSView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        HTMLView(htmlFileName: "TermsOfService")
//            .frame(width: 380.0, height: 700.0)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("arrowLeft")
                })
                .accentColor(Palette.greyHard)
            )
    }
}
