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
                            NavigationLink(destination: EditVehicleView(dataVM: dataVM, vehicleS: VehicleState.fromVehicleViewModel(vm: vehicle))){
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

struct EditVehicleView : View {
    
    @FocusState var focusedField: FocusFieldBoarding?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var dataVM : DataViewModel
    
    @State var vehicleS : VehicleState
    
    var isDisabled : Bool {
        return vehicleS.name.isEmpty || vehicleS.brand.isEmpty || vehicleS.model.isEmpty
    }
    
    var body: some View {
        ZStack{
            Palette.greyBackground.ignoresSafeArea()
            VStack(spacing:20){
                
                TextField("Car's name", text: $vehicleS.name)
                    .disableAutocorrection(true)
                    .focused($focusedField,equals: .carName)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .carName ? Palette.greyLight :Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .carName ? Palette.black :Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $vehicleS.name))
                    .onSubmit {
                        focusedField = .brand
                    }
                
                TextField("Brand", text: $vehicleS.brand)
                    .disableAutocorrection(true)
                    .focused($focusedField,equals: .brand)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .brand ? Palette.greyLight :Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .brand ? Palette.black :Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $vehicleS.brand))
                    .onSubmit {
                        focusedField = .model
                    }
                
                TextField("Model", text: $vehicleS.model)
                    .disableAutocorrection(true)
                    .focused($focusedField,equals: .model)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .model ? Palette.greyLight :Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .model ? Palette.black :Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $vehicleS.model))
                    .onSubmit {
                        focusedField = nil
                    }
                
                Spacer()
            }
            .padding(.vertical,30)
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
                        }
                        catch{
                            print(error)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                            .font(Typography.headerM)
                    }
                          )
                    .disabled(isDisabled)
                    .opacity(isDisabled ? 0.6 : 1)
            )
            .toolbar{
                ToolbarItem(placement: .principal) {
                    Text(vehicleS.name)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
            
        }
    }
}
