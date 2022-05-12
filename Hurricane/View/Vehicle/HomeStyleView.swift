//
//  Home.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/05/22.
//

import SwiftUI

struct HomeStyleView: View {
    var topEdge : CGFloat
    let maxHeight = UIScreen.main.bounds.height / 2.5
    
    //Offset
    @State var offset:  CGFloat = 0
    
    var body: some View {
        
        ScrollView(.vertical,showsIndicators: true){
            VStack(spacing: 15){
                
                GeometryReader{ proxy in
                    
                    HeaderView(offset: $offset, maxHeight: maxHeight)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                    // sticky effect
                        .frame(height: getHeaderHeight(),alignment: .bottom)
                        .background(Color.blue,in: CustomCorner(corners: [.bottomRight], radius: getCornerRadius()))
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
                VStack(spacing: 15){
                    ScrollView{
                        
                        Text("Don't know where you get your skills, but it's crazy good! Thanks for all the wonderful content you create for the community 🙌🏻")
                        Text("Don't know where you get your skills, but it's crazy good! Thanks for all the wonderful content you create for the community 🙌🏻")
                        Text("Don't know where you get your skills, but it's crazy good! Thanks for all the wonderful content you create for the community 🙌🏻")
                        Text("Don't know where you get your skills, but it's crazy good! Thanks for all the wonderful content you create for the community 🙌🏻")
                        
                        
                    }  .padding()
                    
                }
                .padding()
                .zIndex(0)
            }
            .modifier(OffsetModifier(offset: $offset))
        }
        // Setting the coordinate space
        .coordinateSpace(name: "SCROLL")
        
    }
    func getHeaderHeight() -> CGFloat {
        
        let topHeight = maxHeight + offset
        
        // 80 is the costant top nav bar height
        // since we included top safe area so we also need to include that too
        return topHeight > (80 + topEdge) ? topHeight
        : (80 + topEdge)
    }
    
    func getCornerRadius() -> CGFloat {
        
        let progress = -offset / (maxHeight - (80+topEdge))
        
        let value = 1 - progress
        let radius = value * 50
        
        return offset < 0 ? radius : 50
    }
    
    func topBarTitleOpacity() -> CGFloat {
        // to start after the main content vanished
        // we nee to eliminate 70 from the offset
        // to get starter..
        let progress = -(offset + 70) / (maxHeight - (80 + topEdge))
        
        return progress
    }
    
    
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        VehicleView()
    }
}

struct TopNav : View {
    
    @Binding var offset: CGFloat
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Batman's car >")
                    .foregroundColor(Palette.black)
                    .font(Typography.headerXL)
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
                        }
                        
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

struct HeaderView : View {
    @Binding var offset: CGFloat
    var maxHeight : CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            
            
            
            Text("In this Video I'm going to show how to create a Stylish Collapsable Animated Header Using SwiftUI 3.0 - SwiftUI Animated Header - SwiftUI Complex UI - SwiftUI Custom Scroll Animation's - SwiftUI ")
            
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
