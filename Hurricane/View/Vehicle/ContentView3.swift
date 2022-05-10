//
//  ContentView3.swift
//  Hurricane
//
//  Created by Asya Tealdi on 06/05/22.
//

import SwiftUI

struct ContentView3: View {
    
    @State var offset: CGFloat = 0
    @State var startOffset: CGFloat = 0
    @State var titleOffset: CGFloat = 0
    @State var titleBarHeight: CGFloat = 0
    var categories = ["Crossroads","Crossroads","Crossroads"]
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                VStack{
                VStack {
                    HStack {
                        //Title
                        Text("Batman's Car >")
                            .font(Typography.headerXL)
                            .foregroundColor(Palette.black)
                        Spacer()
                        //Per month Button
                        Button {
                            print("Button is tapped")
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 50)
                                    .foregroundColor(.white)
                                Text("Per month")
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                            }
                            .frame(width: 80, height: 25, alignment: .center)
                        }
                        //Bell ring button
                        Button {
                            print("Bell is tapped")
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 100)
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .foregroundColor(.white)
                                Image(systemName: "bell")
                                    .foregroundColor(.black)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .font(.title)
//                    .overlay(
//                        GeometryReader { reader -> Color in
//
//                            let width = reader.frame(in: .global).maxX
//
//                            DispatchQueue.main.async {
//                                if titleOffset == 0 {
//                                    titleOffset = width
//                                }
//                            }
//                            return Color.clear
//                        }
//                            .frame(width: 0, height: 0)
//                    )
//                    .offset(getOffSet())
                    //Model text
                    HStack{
                        Text("Range Rover Evoque, 2017")
                        Spacer()
                    }
                    Spacer()
                }
                .padding(25)
                .frame(width: 430, height: 100, alignment: .topLeading)

                //Stats views
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<3) { _ in
                            StatView()
                        }
                    }
                    .frame(width: 430, height: 100, alignment: .center)
             
                }
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        HStack{
                            Text("Last Events")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Button {
                                print("View all tapped")
                            } label: {
                                Text("View all >")
                                    .foregroundColor(Palette.greyHard)
                            }

                            
                        }
                        .padding(5)
                        
                            
                        ForEach(categories,  id:\.self) { category in
                            HStack{
                                ZStack{
                                    Circle()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(Palette.colorOrange)
                                    Image(systemName: "drop.fill")
                                        .resizable()
                                        .blendMode(.screen)
                                        .frame(width: 12, height: 16)
                                        .foregroundColor(.white)
                                }
                                VStack{
                                    Text(category)
                                        .font(Typography.headerM)
                                        .foregroundColor(Palette.black)
                                        .padding(.leading,5)
                                    Text("Products")
                                        .foregroundColor(Palette.greyHard)
                                    
                                }
                                
                                Spacer()
                                
                                Text("–$ 2 302")
                                    .foregroundColor(Palette.greyHard)
                            }
                        }
                        
                        
                        HStack{
                            Text("Documents")
                                .font(.title2)
                                .fontWeight(.bold)
                              
                            Spacer()
                          
                        }
                        .padding(5)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<2) { _ in
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 30)
                                            .frame(width: 128, height: 110)
                                            .foregroundColor(.white)
                                        VStack{
                                            HStack{
                                                ZStack{
                                                    
                                                    Circle()
                                                        .frame(width: 24, height: 24)
                                                        .foregroundColor(Palette.greyLight)
                                                    Image(systemName: "text.book.closed")
                                                
                                                }
                                                .padding(5)
                                                Spacer()
                                            }
                                            Spacer()
                                            Text("Driving license")
                                                .fontWeight(.medium)
                                        }
                                        .padding()
                                    }
                                }
                                
                                Button {
                                    print("Creating new doc")
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 30)
                                            .frame(width: 128, height: 110)
                                        VStack{
                                            Text("+")
                                            Text("Add Document")
                                        }
                                        .foregroundColor(.white)
                                    }
                                }

                                
                            }
                        }
                        
                    }
//                    .overlay(
//                        GeometryReader { proxy -> Color in
//                            let minY = proxy.frame(in: .global).minY
//
//                            DispatchQueue.main.async {
//                                if startOffset == 0 {
//                                    startOffset = minY
//                                }
//
//                                offset = startOffset - minY
//                                print(offset)
//                            }
//
//                            return Color.clear
//                        }
//                            .frame(width: 0, height: 0)
//                        ,alignment: .top
//                    )
                    
                }
              
                .padding(25)
                .background(Palette.greyBackground.ignoresSafeArea(.container, edges: .bottom))
                .cornerRadius(60)
//                LastEventsView()
                
            
                
                
              
            }
            .zIndex(1)
            .padding(.bottom, getOffSet().height)
            .background(Palette.greyBackground)
//            .overlay(
//                GeometryReader { reader -> Color in
//
//                    let height = reader.frame(in: .global).maxY
//
//                    DispatchQueue.main.async {
//                        if titleBarHeight == 0 {
//                            titleBarHeight = height - (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
//                            }
//                    }
//                    return Color.clear
//
//                }
//            )
            
        }
//        .overlay(
//            VStack{
//                Spacer(minLength: UIScreen.main.bounds.size.height * 0.77)
//                Button(action: {
//                    
//                    //       vehicleVM.addExpense(expense: expense)
//                    //       vehicleVM.getExpenses()
//                }, label: {
//                    AddReportButton(text: "Add report")
//                })
//                Spacer()
//            }
//            //                    .padding(.top,50)
//        )
    }
    
    func getOffSet()->CGSize {
        var size: CGSize = .zero
        let screenWidth = UIScreen.main.bounds.width / 2
        size.width = offset > 0 ? (offset * 1.5 <= (screenWidth - titleOffset) ? offset * 1.5 : (screenWidth - titleOffset)) : 0
        size.height = offset > 0 ? (-offset) : 0
        return size
    }
}

struct HeaderView {
    
    var body: some View {
        ZStack{
            Palette.greyBackground
                .ignoresSafeArea()
            
            Text("Hi")
        }
        
    }
}

struct ContentView3_Previews: PreviewProvider {
    static var previews: some View {
        ContentView3()
    }
}
