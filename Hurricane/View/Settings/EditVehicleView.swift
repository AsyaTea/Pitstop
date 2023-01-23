//
//  EditVehicleView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 22/05/22.
//

import SwiftUI

struct EditVehicleView: View {
    @FocusState var focusedField: FocusFieldBoarding?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var dataVM: DataViewModel

    @State var vehicle: VehicleViewModel
    @State var vehicleS: VehicleState

    @State private var defaultFuelPicker = false
    @State private var secondaryFuelPicker = false
    @State private var isTapped = false
    @State private var isTapped2 = false

    @StateObject var fuelVM = FuelViewModel()

    var isDisabled: Bool {
        vehicleS.name.isEmpty || vehicleS.brand.isEmpty || vehicleS.model.isEmpty || vehicleS.fuelTypeOne == 7
    }

    var body: some View {
        ZStack {
            Palette.greyBackground.ignoresSafeArea()
            VStack(spacing: 20) {
                TextField(String(localized: "Vehicle name"), text: $vehicleS.name)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .carName)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .carName ? Palette.greyLight : Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .carName ? Palette.black : Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $vehicleS.name))
                    .onSubmit {
                        focusedField = .brand
                    }

                TextField(String(localized: "Brand"), text: $vehicleS.brand)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .brand)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .brand ? Palette.greyLight : Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .brand ? Palette.black : Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $vehicleS.brand))
                    .onSubmit {
                        focusedField = .model
                    }

                TextField(String(localized: "Model"), text: $vehicleS.model)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .model)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .model ? Palette.greyLight : Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .model ? Palette.black : Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $vehicleS.model))
                    .onSubmit {
                        focusedField = .plate
                    }

                TextField(String(localized: "Plate"), text: $vehicleS.plate)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .plate)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .plate ? Palette.greyLight : Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .plate ? Palette.black : Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $vehicleS.plate))
                    .onSubmit {
                        focusedField = nil
                    }

                // MARK: DEFAULT FUEL TYPE

                Button(action: {
                    defaultFuelPicker.toggle()
                    isTapped.toggle()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(isTapped ? Palette.black : Palette.greyInput, lineWidth: 1)
                            .background(isTapped ? Palette.greyLight : Palette.greyBackground)
                            .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                        HStack {
                            Text(vehicle.fuelTypeOne.label)
                                .font(Typography.TextM)
                            Spacer()
                        }
                        .padding(.leading, 40)
                    }
                    .accentColor(Palette.black)
                })
                .confirmationDialog(String(localized: "Select a default fuel type"), isPresented: $defaultFuelPicker, titleVisibility: .visible) {
                    ForEach(FuelType.allCases, id: \.self) { fuel in

                        Button(fuel.label) {
                            isTapped = false
                            fuelVM.defaultFuelType = fuel
                            vehicle.fuelTypeOne = fuel // THIS IS NEEDED TO UPDATE THE LABEL IN THE VIEW
                            vehicleS.fuelTypeOne = fuelVM.defaultSelectedFuel // THIS PASS THE VALUE OF THE FUEL ON VEHICLE STATE
                        }
                    }
                }

                // MARK: SECONDARY FUEL TYPE

                Button(action: {
                    secondaryFuelPicker.toggle()
                    isTapped2.toggle()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(isTapped2 ? Palette.black : Palette.greyInput, lineWidth: 1)
                            .background(isTapped2 ? Palette.greyLight : Palette.greyBackground)
                            .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                        HStack {
                            Text(vehicle.fuelTypeTwo.label)
                                .font(Typography.TextM)
                            Spacer()
                        }
                        .padding(.leading, 40)
                    }
                    .accentColor(Palette.black)
                })
                .confirmationDialog(String(localized: "Select a second fuel type"), isPresented: $secondaryFuelPicker, titleVisibility: .visible) {
                    ForEach(FuelType.allCases, id: \.self) { fuel in

                        Button(fuel.label) {
                            isTapped2 = false
                            fuelVM.secondaryFuelType = fuel
                            vehicle.fuelTypeTwo = fuel // THIS IS NEEDED TO UPDATE THE LABEL IN THE VIEW
                            vehicleS.fuelTypeTwo = fuelVM.secondarySelectedFuel // THIS PASS THE VALUE OF THE FUEL ON VEHICLE STATE
                        }
                    }
                }

                Spacer()
            }
            .padding(.vertical, 30)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("arrowLeft")
                })
                .accentColor(Palette.greyHard),
                trailing:
                Button(action: {
                    do {
                        try dataVM.updateVehicle(vehicleS)
                    } catch {
                        print(error)
                    }
                    presentationMode.wrappedValue.dismiss()
                    fuelVM.resetSelectedFuel()
                }, label: {
                    Text(String(localized: "Save"))
                        .font(Typography.headerM)
                })
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.6 : 1)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(vehicle.name)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
        }
    }
}

// struct EditVehicleView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditVehicleView()
//    }
// }
