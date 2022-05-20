//
//  Home.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/05/22.
//

import SwiftUI
import Foundation

struct HomeStyleView: View {
    
    @StateObject var homeVM = HomeViewModel()
    @ObservedObject var dataVM : DataViewModel
    
    //Scroll animation vars
    @State var offset:  CGFloat = 0
    @State var topEdge : CGFloat
    let maxHeight = UIScreen.main.bounds.height / 3.6
    
    var body: some View {
        ZStack{
            ScrollView(.vertical,showsIndicators: false){
                VStack(spacing: 15){
                    
                    GeometryReader{ proxy in
                        //MARK: HEADER CONTENT
                        HeaderContent(offset: $offset, maxHeight: maxHeight, dataVM: dataVM)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .opacity(
                                withAnimation(.easeOut){ fadeOutOpacity()}
                            )
                        
                        // sticky effect
                            .frame(height: getHeaderHeight(),alignment: .bottom)
                            .background(Palette.colorYellow)
                            .overlay(
                                //MARK: TOP NAV BAR
                                TopNav(dataVM: dataVM, offset: offset, maxHeight: maxHeight, topEdge:topEdge)
                                    .padding(.horizontal)
                                    .frame(height: 60)
                                    .padding(.top,topEdge+10)
                                
                                ,alignment: .top
                            )
                    }
                    .frame(height: maxHeight)
                    // Fixing at top
                    .offset(y: -offset)
                    .zIndex(1)
                    
                    //MARK: BOTTOM VIEW
                    ZStack{
                        
                        BottomContentView(homeVM: homeVM)
                            .background(Palette.greyBackground,in: CustomCorner(corners: [.topLeft,.topRight], radius: getCornerRadius()))
                    }
                    .background(Palette.colorYellow)
                    .padding(.top,-15)
                    .zIndex(0)
                }
                .modifier(OffsetModifier(offset: $offset))
            }
            .background(Palette.greyBackground)
            .coordinateSpace(name: "SCROLL")
            .disabled(homeVM.showAlertNumbers)
            .overlay(
                ZStack{
                    homeVM.showAlertNumbers ? Color.black.opacity(0.4) : Color.clear
                }
            )
            
            //SHOW THE ALLERT IF TOGGLED
            if(homeVM.showAlertNumbers){
                Spacer()
                AlertAddNumbers(homeVM: homeVM)
                Spacer()
            }
        }
    }
    
    func getHeaderHeight() -> CGFloat {
        
        let topHeight = maxHeight + offset
        
        // 60 is the costant top nav bar height
        // since we included top safe area so we also need to include that too
        return topHeight > (60 + topEdge) ? topHeight
        : (60 + topEdge)
    }
    
    func getCornerRadius() -> CGFloat {
        
        let progress = -offset / (maxHeight - (60+topEdge))
        
        let value = 1 - progress
        let radius = value * 35
        
        return offset < 0 ? radius : 35
    }
    
    // Opacity to let appear items in the top bar
    func fadeInOpacity() -> CGFloat {
        // to start after the main content vanished
        // we nee to eliminate 70 from the offset
        // to get starter..
        let progress = -(offset + 70) / (maxHeight - (60 + topEdge * 3.2))
        
        return progress
    }
    
    // Opacity to let items in top bar disappear on scroll
    func fadeOutOpacity() -> CGFloat {
        // 70 = Some rnadom amount of time to visible on scroll
        
        let progress = -offset / 70
        let opacity = 1 - progress
        
        return offset < 0 ? opacity : 1
    }
    
    
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        VehicleView()
//    }
//}



struct TopNav : View {
    
    @StateObject var dataVM : DataViewModel
    
    var offset: CGFloat
    let maxHeight : CGFloat
    var topEdge : CGFloat
    //    var homeVM : HomeViewModel
    
    // Opacity to let appear items in the top bar
    func fadeInOpacity() -> CGFloat {
        // to start after the main content vanished
        // we nee to eliminate 70 from the offset
        // to get starter..
        let progress = -(offset + 70) / (maxHeight - (60 + topEdge * 3.2))
        
        return progress
    }
    
    // Opacity to let items in top bar disappear on scroll
    func fadeOutOpacity() -> CGFloat {
        // 70 = Some rnadom amount of time to visible on scroll
        
        let progress = -offset / 70
        let opacity = 1 - progress
        
        return offset < 0 ? opacity : 1
    }
    
    @State private var showingAllCars = false
    
    let filter = NSPredicate(format: "current == %@","1")
    
    var brandModelString : String {
        return "\(dataVM.currentVehicle.first?.brand ?? "brand") \(dataVM.currentVehicle.first?.model ?? "model")"
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Button(action: {
                    showingAllCars.toggle()
                }, label: {
                    HStack{
                        Text(dataVM.currentVehicle.first?.name ?? "Default's car ")
                            .foregroundColor(Palette.black)
                            .font(Typography.headerXL)
                            .opacity(fadeOutOpacity())
                        Image("arrowLeft")
                            .resizable()
                            .foregroundColor(Palette.black)
                            .frame(width: 10, height: 14)
                            .rotationEffect(Angle(degrees: 270))
                            .padding(.top,3)
                            .padding(.leading,-3)
                    }
                    .padding(.leading,-1)
                    .opacity(fadeOutOpacity())
                })
                .confirmationDialog("Select a car", isPresented: $showingAllCars, titleVisibility: .hidden) {
                    ForEach(dataVM.vehicleList,id:\.vehicleID){ vehicle in
                        Button(vehicle.name) {
                            //DEVO SETTARE IL CURRENT VEHICLE
                            var vehicleS = VehicleState.fromVehicleViewModel(vm: vehicle)
                            dataVM.setAllCurrentToFalse()
                            vehicleS.current = 1 // SETTO IL CURRENT TO TRUE
                    
                            do{
                                if(vehicleS.vehicleID != nil){
                                try dataVM.updateVehicle(vehicleS)
                                    print("updato to current")
                                    dataVM.currentVehicle.removeAll()
                                    dataVM.currentVehicle.append(vehicle)
                            }
                            else{
                                print("error")
                            }
                            }
                            catch{
                                print(error)
                            }
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                        .background(.black)
                        .foregroundColor(.red)
                }
                
                
                Spacer()
                HStack{
                    Button(action: {
                        
                    }, label: {
                        ZStack{
                            Rectangle()
                                .foregroundColor(Palette.white)
                                .cornerRadius(37)
                                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.04)
                                .shadowGrey()
                            HStack{
                                Text("Per month")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.ControlS)
                                Image("arrowDown")
                                
                            }
                        }.opacity(fadeOutOpacity())
                    })
                    
                    ZStack{
                        Button(action: {
                            
                        }, label: {
                            ZStack{
                                Circle()
                                    .foregroundColor(Palette.white)
                                    .frame(width: UIScreen.main.bounds.width * 0.09, height: UIScreen.main.bounds.height * 0.04)
                                    .shadowGrey()
                                Image("bellHome")
                            }
                        })
                    }
                }
                .padding(.top,2)
            }
            Text(brandModelString)
                .foregroundColor(Palette.black)
                .font(Typography.TextM)
                .padding(.top,-12)
                .opacity(fadeOutOpacity())
        }
        .task{
            //Fetch current vehicle from DB
            dataVM.getVehiclesCoreData(filter: filter, storage:{ storage in
                dataVM.currentVehicle = storage
            })
        }
        .overlay(
            VStack(alignment: .center,spacing: 2){
                Text(dataVM.currentVehicle.first?.name ?? "Default's car ")
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                Text(brandModelString)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
            }
                .opacity(
                    withAnimation(.easeInOut){
                        fadeInOpacity()
                    })
                .padding(.bottom,15)
        )
    }
}

struct HeaderContent : View {
    @Binding var offset: CGFloat
    var maxHeight : CGFloat
    
    @StateObject var dataVM : DataViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            HStack(spacing:13){
                
                Button(action: {
                    
                }, label: {
                    ZStack{
                        Rectangle()
                            .cornerRadius(16)
                            .foregroundColor(Palette.colorMainYellow)
                            .frame(width: UIScreen.main.bounds.width * 0.29, height: UIScreen.main.bounds.height * 0.09)
                        VStack(alignment: .center){
                            Text("23,4k $")
                                .foregroundColor(Palette.black)
                                .font(Typography.headerL)
                            Text("All costs")
                                .foregroundColor(Palette.black)
                                .font(Typography.TextM)
                        }
                    }
                })
                
                Button(action: {
                    
                }, label: {
                    ZStack{
                        Rectangle()
                            .cornerRadius(16)
                            .foregroundColor(Palette.colorMainYellow)
                            .frame(width: UIScreen.main.bounds.width * 0.29, height: UIScreen.main.bounds.height * 0.09)
                        VStack(alignment: .center){
                            Text(String(dataVM.currentVehicle.first?.odometer ?? 0))
                                .foregroundColor(Palette.black)
                                .font(Typography.headerL)
                            Text("Odometer")
                                .foregroundColor(Palette.black)
                                .font(Typography.TextM)
                        }
                    }
                })
                
                Button(action: {
                    
                }, label: {
                    ZStack{
                        Rectangle()
                            .cornerRadius(16)
                            .foregroundColor(Palette.colorMainYellow)
                            .frame(width: UIScreen.main.bounds.width * 0.29, height: UIScreen.main.bounds.height * 0.09)
                        VStack(alignment: .center){
                            Text("23,4k $")
                                .foregroundColor(Palette.black)
                                .font(Typography.headerL)
                            Text("Average")
                                .foregroundColor(Palette.black)
                                .font(Typography.TextM)
                        }
                    }
                })
            }
        }
        .padding()
        .padding(.bottom)
    }
}

struct OffsetModifier: ViewModifier {
    
    @Binding var offset: CGFloat
    
    func body(content: Content) -> some View {
        
        content
            .overlay(
                GeometryReader{ proxy -> Color in
                    
                    // getting value for coordinate space called scroll
                    let minY = proxy.frame(in: .named("SCROLL")).minY
                    
                    DispatchQueue.main.async {
                        self.offset = minY
                    }
                    
                    return Color.clear
                }
                ,alignment: .top
            )
    }
}

struct CustomCorner : Shape {
    
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d, EE")
        return dateFormatter.string(from: self)
    }
}
