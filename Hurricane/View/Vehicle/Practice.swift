//
//  Practice.swift
//  Hurricane
//
//  Created by Asya Tealdi on 10/05/22.
//

import SwiftUI

struct Practice: View {
    @State var headerOffsets: (CGFloat, CGFloat) = (0, 0)
    var body: some View {
        VStack {
            TitleView()
                .background(Palette.colorViolet)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    HeaderView()

                    GeometryReader { mainView in

                        GeometryReader { item in

                            PinnedHeaderView()
                                .background(Color.white)
//                                .offset(y: headerOffsets.1 > 0 ? 0: -headerOffsets.1 / 8)
                                .modifier(OffsetModifier(offset: $headerOffsets.0, returnFromStart: false))
                                .modifier(OffsetModifier(offset: $headerOffsets.1))
                                .scaleEffect(scaleValue(mainFrame: mainView.frame(in: .global).minY, minY: item.frame(in: .global).minY))
                        }
                        .frame(height: 650)
                    }
                }
            }
            .overlay(content: {
                Rectangle()
                    .fill(.black)
                    .frame(height: 50)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .opacity(headerOffsets.0 < 20 ? 1 : 0)
            })

            .coordinateSpace(name: "Scroll")
            .ignoresSafeArea(.container, edges: .vertical)
        }

        .background(Palette.colorViolet)
    }

    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("Scroll")).minY
            let size = proxy.size
            let height = size.height + minY

//                Image("images")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: size.width, height: height, alignment: .top)
//                .scaleEffect(10)
//                .offset(y: -minY)
            HStack {
                StatView()
                    .padding(5)
            }
            .scaleEffect() // ???
            .frame(width: size.width, height: height, alignment: .top)
            .offset(y: -minY)
            .background(Palette.colorViolet).ignoresSafeArea()
        }
        .frame(height: 95)
    }

    func PinnedHeaderView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                MainPageScroll()
                MainPageScroll()
                MainPageScroll()
                    .frame(width: 380, height: 620, alignment: .center)
            }
            .zIndex(1)
            .padding()
        }
    }

    func scaleValue(mainFrame: CGFloat, minY: CGFloat) -> CGFloat {
        let scale = minY / mainFrame

        if scale > 1 {
            print(scale)
            return 1
        } else {
            return scale
        }
    }
}

struct TitleView: View {
    var body: some View {
        HStack {
            VStack {
                HStack {
                    // Title
                    Text("Barman's Car >")
                        .font(Typography.headerXL)
                        .foregroundColor(Palette.black)
                    Spacer()
                    // Per month Button
                    Button {
                        print("Button is tapped")
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundColor(.white)
                            Text("Per month")
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                        }
                        .frame(width: 80, height: 25, alignment: .center)
                    }
                    // Bell ring button
                    Button {
                        print("Bell is tapped")
                    } label: {
                        ZStack {
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
                // Model text
                HStack {
                    Text("Range Rover Evoque, 2017")
                    Spacer()
                }
                Spacer()
            }
            .padding(25)
            .frame(width: 430, height: 100, alignment: .topLeading)
        }
    }
}

struct OffsetModifier: ViewModifier {
    @Binding var offset: CGFloat

    var returnFromStart: Bool = true
    @State var startValue: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: OffsetKey.self, value: proxy.frame(in: .named("Scroll")).midY)
                        .onPreferenceChange(OffsetKey.self) { value in
                            if startValue == 0 {
                                startValue = value
                            }
                            offset = (value - (returnFromStart ? startValue : 0))
                        }
                }
            }
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct Practice_Previews: PreviewProvider {
    static var previews: some View {
        Practice()
    }
}
