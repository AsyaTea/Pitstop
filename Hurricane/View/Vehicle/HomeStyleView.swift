//
//  Home.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/05/22.
//

import SwiftUI
import Foundation

struct HomeStyleView: View {
    var topEdge : CGFloat
    let maxHeight = UIScreen.main.bounds.height / 3.6
    
    //Offset
    @State var offset:  CGFloat = 0
    
    var body: some View {
        
        ScrollView(.vertical,showsIndicators: false){
            VStack(spacing: 15){
                
                GeometryReader{ proxy in
                    
                    HeaderContent(offset: $offset, maxHeight: maxHeight)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                       
                    // sticky effect
                        .frame(height: getHeaderHeight(),alignment: .bottom)
                        .background(Palette.colorBlue,in: CustomCorner(corners: [.bottomRight,.bottomLeft], radius: getCornerRadius()))
                        .overlay(
                            //Top nav view
                            TopNav(offset: $offset)
                                .padding(.horizontal)
                                .frame(height: 60)
                                .padding(.top,topEdge)
                            ,alignment: .top
                        )
                }
                .frame(height: maxHeight)
                // Fixing at top
                .offset(y: -offset)
                .zIndex(1)
                // BOTTOM VIEW
                VStack(spacing: 0){
                    
                    BottomContent()
                       
                    
                }
               
//                .padding()
                .zIndex(0)
            }
            .modifier(OffsetModifier(offset: $offset))
        }
        .background(Palette.greyBackground)
        // Setting the coordinate space
        .coordinateSpace(name: "SCROLL")
        
    }
    func getHeaderHeight() -> CGFloat {
        
        let topHeight = maxHeight + offset
        
        // 80 is the costant top nav bar height
        // since we included top safe area so we also need to include that too
        return topHeight > (60 + topEdge) ? topHeight
        : (60 + topEdge)
    }
    
    func getCornerRadius() -> CGFloat {
        
        let progress = -offset / (maxHeight - (60+topEdge))
        
        let value = 1 - progress
        let radius = value * 50
        
        return offset < 0 ? radius : 50
    }
    
    func topBarTitleOpacity() -> CGFloat {
        // to start after the main content vanished
        // we nee to eliminate 70 from the offset
        // to get starter..
        let progress = -(offset + 70) / (maxHeight - (60 + topEdge))
        
        return progress
    }
    
    
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        VehicleView()
    }
}

struct BottomContent : View {
    
    
    var body: some View {
        
        titleSectionComponent(sectionTitle: "Last events")
            .padding()
        categoryComponent(categoryName: "Fuel", date: Date.now, cost: "2302")
        categoryComponent(categoryName: "Fuel", date: Date.now, cost: "2302")
        categoryComponent(categoryName: "Fuel", date: Date.now, cost: "2302")
          
        titleSectionComponent(sectionTitle: "Documents")
            .padding()
        ScrollView(.horizontal,showsIndicators: false){
            VStack {
                Spacer(minLength: 12)
            HStack{
                Button(action: {
                   
                }, label: {
                    documentComponent(title: "Driving license")
                })
                Button(action: {
                    
                }, label: {
                    addComponent(title: "Add document")
                })
               
            }
                Spacer(minLength: 16)
            }
            
        }
        .safeAreaInset(edge: .trailing, spacing: 0) {
            Spacer()
                .frame(width: 16)
        }
        .safeAreaInset(edge: .leading, spacing: 0) {
            Spacer()
                .frame(width: 16)
        }
        
        titleSectionComponent(sectionTitle: "Important numbers")
            .padding()
        ScrollView(.horizontal,showsIndicators: false){
            VStack {
                Spacer(minLength: 12)
            HStack{
                Button(action: {
                   
                }, label: {
                    importantNumbersComponent(title: "Service", number: "366 4925454")
                })
                Button(action: {
                    
                }, label: {
                    addComponent(title: "Add number")
                })
               
            }
                Spacer(minLength: 16)
            }
            
        }
        .safeAreaInset(edge: .trailing, spacing: 0) {
            Spacer()
                .frame(width: 16)
        }
        .safeAreaInset(edge: .leading, spacing: 0) {
            Spacer()
                .frame(width: 16)
        }
        
        Spacer()
    }
    
    @ViewBuilder
    func categoryComponent(categoryName : String, date: Date, cost : String) -> some View {
        
        let formatted = date.formatDate()
        
        HStack{
            ZStack{
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Palette.colorYellow)
                Image("Fuel")
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            VStack(alignment: .leading){
                Text(categoryName)
                    .foregroundColor(Palette.black)
                    .font(Typography.headerS)
                Text(formatted)
                    .foregroundColor(Palette.greyMiddle)
                    .font(Typography.TextM)
                
            }
            Spacer()
            VStack{
            Text("–$ \(cost)")
                .foregroundColor(Palette.greyHard)
                .font(Typography.headerS)
            Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical,10)
        
    }
    
    @ViewBuilder
    func titleSectionComponent(sectionTitle: String) -> some View {
        HStack{
            Text(sectionTitle)
                .foregroundColor(Palette.black)
                .font(Typography.headerL)
            Spacer()
            HStack{
                Button(action:{
                }, label: {
                    Text("View all")
                        .font(Typography.ControlS)
                        .foregroundColor(Palette.greyMiddle)
                    Image("arrowLeft")
                        .resizable()
                        .foregroundColor(Palette.greyMiddle)
                        .frame(width: 5, height: 9)
                        .rotationEffect(Angle(degrees: 180))
                })
                
            }
        }
    }
    
    @ViewBuilder
    func documentComponent(title: String) -> some View {
        ZStack{
            Rectangle()
                .cornerRadius(8)
                .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.11)
                .foregroundColor(Palette.white)
                .shadowGrey()
            VStack(alignment: .leading, spacing: 30){
                ZStack{
                    Circle()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Palette.greyLight)
                    Image("documents")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(Palette.black)
                }
                Text(title)
                    .foregroundColor(Palette.black)
                    .font(Typography.ControlS)
            }
            .padding(.leading,-24)
            .padding(.top,-2)
        }
    }
    
    @ViewBuilder
    func importantNumbersComponent(title: String, number: String) -> some View {
        ZStack{
            Rectangle()
                .cornerRadius(8)
                .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.11)
                .foregroundColor(Palette.white)
                .shadowGrey()
            VStack(alignment: .leading, spacing: 16){
                ZStack{
                    Circle()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Palette.greyLight)
                    Image("service")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(Palette.black)
                }
                VStack(alignment: .leading,spacing:3){
                Text(title)
                    .foregroundColor(Palette.black)
                    .font(Typography.ControlS)
                Text(number)
                    .foregroundColor(Palette.greyMiddle)
                    .font(Typography.TextM)
                }
            }
            .padding(.leading,-26)
            .padding(.top,-2)
        }
    }
    
    @ViewBuilder
    func addComponent(title : String) -> some View {
        ZStack{
            Rectangle()
                .cornerRadius(8)
                .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.11)
                .foregroundColor(Palette.white)
                .shadowGrey()
            VStack(alignment: .center, spacing: 10){
                Image("plus")
                    .foregroundColor(Palette.greyMiddle)
                Text(title)
                    .foregroundColor(Palette.greyMiddle)
                    .font(Typography.ControlS)
            }
        }
    }
}

struct TopNav : View {
    
    @Binding var offset: CGFloat
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                HStack{
                Text("Batman's car ")
                    .foregroundColor(Palette.black)
                    .font(Typography.headerXL)
                    Image("arrowLeft")
                        .resizable()
                        .foregroundColor(Palette.black)
                        .frame(width: 10, height: 14)
                        .rotationEffect(Angle(degrees: 180))
                        .padding(.top,3)
                        .padding(.leading,-5)
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
                        }.opacity(getOpacity())
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
            }
            Text("Range Rover Evoque, 2017")
                .foregroundColor(Palette.black)
                .font(Typography.TextM)
                .padding(.top,-12)
                .opacity(getOpacity())
        }
    }
    
    // Opacity
    func getOpacity() -> CGFloat {
        // 70 = Some rnadom amount of time to visible on scroll
        
        let progress = -offset / 70
        let opacity = 1 - progress
        
        return offset < 0 ? opacity : 1
    }
}

struct HeaderContent : View {
    @Binding var offset: CGFloat
    var maxHeight : CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            HStack(spacing:13){
                
                Button(action: {
                    
                }, label: {
                    ZStack{
                        Rectangle()
                            .cornerRadius(16)
                            .foregroundColor(Palette.colorMainBlue)
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
                            .foregroundColor(Palette.colorMainBlue)
                            .frame(width: UIScreen.main.bounds.width * 0.29, height: UIScreen.main.bounds.height * 0.09)
                        VStack(alignment: .center){
                            Text("23842")
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
                            .foregroundColor(Palette.colorMainBlue)
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
        .opacity(getOpacity())
    }
    
    // Opacity
    func getOpacity() -> CGFloat {
        // 70 = Some rnadom amount of time to visible on scroll
        
        let progress = -offset / 70
        let opacity = 1 - progress
        
        return offset < 0 ? opacity : 1
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
