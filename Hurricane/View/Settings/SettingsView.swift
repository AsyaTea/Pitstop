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

    var body: some View {
        NavigationView {
            VStack {
                Text("") // FIX: Workaround to not overlap  list on navigation title
                CustomList {
                    Section(header: Text("Vehicles")) {
                        ForEach(dataVM.vehicleList, id: \.self) { vehicle in
                            let destination = EditVehicleView(dataVM: dataVM, vehicle: vehicle, vehicleS: VehicleState.fromVehicleViewModel(vm: vehicle))
                            NavigationLink(destination: destination) {
                                CategoryRow(title: vehicle.name, iconName: "car-settings", color: Palette.colorViolet)
                            }
                        }
                        .onDelete(perform: dataVM.deleteVehicle)

                        Button(action: {
                            onboardingVM.addNewVehicle = true
                            onboardingVM.destination = .page2
                        }, label: {
                            CategoryRow(title: "Add vehicle ", iconName: "plus", color: Palette.greyBackground)
                        })
                        .buttonStyle(.plain)
                    }
                    .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))

                    Section(header: Text("Other")) {
                        NavigationLink(destination: AboutView()) {
                            CategoryRow(title: "About us ", iconName: "paperclip", color: Palette.greyBackground)
                        }

                        NavigationLink(destination: ToSView()) {
                            CategoryRow(title: "Terms of Service", iconName: "paperclip", color: Palette.greyBackground)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
                }
                .listStyle(.insetGrouped)
                Spacer()
            }
            .fullScreenCover(isPresented: $onboardingVM.addNewVehicle) {
                OnboardingView(onboardingVM: onboardingVM,
                               dataVM: dataVM,
                               categoryVM: categoryVM,
                               shouldShowOnboarding: $onboardingVM.addNewVehicle)
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(dataVM: DataViewModel(),
                     homeVM: HomeViewModel(),
                     onboardingVM: OnboardingViewModel(),
                     categoryVM: CategoryViewModel())
    }
}

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
            .padding()
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
