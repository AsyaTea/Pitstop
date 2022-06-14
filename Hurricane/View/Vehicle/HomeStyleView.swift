//
//  Home.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/05/22.
//

import SwiftUI
import Foundation

struct HomeStyleView: View {
    
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var homeVM: HomeViewModel
    @ObservedObject var categoryVM: CategoryViewModel
    
    @StateObject var utilityVM = UtilityViewModel()
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
                        HeaderContent(offset: $offset, maxHeight: maxHeight, dataVM: dataVM, homeVM: homeVM, utilityVM: utilityVM, categoryVM: categoryVM)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .opacity(
                                withAnimation(.easeOut){ fadeOutOpacity()}
                            )
                        
                        // sticky effect
                            .frame(height: getHeaderHeight(),alignment: .bottom)
                            .background(homeVM.headerBackgroundColor)
                            .overlay(
                                //MARK: TOP NAV BAR
                                TopNav(dataVM: dataVM, utilityVM: utilityVM, categoryVM: categoryVM, offset: offset, maxHeight: maxHeight, topEdge:topEdge)
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
                        
                        BottomContentView(homeVM: homeVM, dataVM: dataVM, utilityVM: utilityVM, categoryVM: categoryVM)
                            .background(Palette.greyBackground,in: CustomCorner(corners: [.topLeft,.topRight], radius: getCornerRadius()))
                    }
                    .background(homeVM.headerBackgroundColor)
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
                AlertAddNumbers(homeVM: homeVM,dataVM: dataVM)
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

