//
//  TabAppearance.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import Foundation
import SwiftUI

struct TabBackView: View {
    let tabbarItems: [TabItemData]
    var height: CGFloat = UIScreen.main.bounds.height * 0.09
    var width: CGFloat = UIScreen.main.bounds.width
    @Binding var selectedIndex: Int

    var body: some View {
        HStack {
            Spacer()

            ForEach(tabbarItems.indices) { index in
                let item = tabbarItems[index]
                Button {
                    self.selectedIndex = index
                } label: {
                    let isSelected = selectedIndex == index
                    TabItemView(data: item, isSelected: isSelected)
                        .padding(.top, -20) // Padding for icons
                }
                Spacer()
            }
        }
        .frame(width: width, height: height)
        .background(Palette.white)
        .shadow(color: .black.opacity(0.04), radius: 1, x: 0, y: -1)
    }
}

struct TabItemView: View {
    let data: TabItemData
    let isSelected: Bool

    var body: some View {
        VStack {
            Image(data.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
//                .animation(.default)
                .foregroundColor(isSelected ? Palette.black : Palette.greyEBEBEB)

        }.frame(width: 75, height: 55) /// Tappable are on icons
    }
}

struct CustomTabView<Content: View>: View {
    let tabs: [TabItemData]
    @Binding var selectedIndex: Int
    @ViewBuilder let content: (Int) -> Content

    var body: some View {
        ZStack {
            TabView(selection: $selectedIndex) {
                ForEach(tabs.indices) { index in
                    content(index)
                        .tag(index)
                }
            }

            VStack {
                Spacer()
                TabBackView(tabbarItems: tabs, selectedIndex: $selectedIndex)
            }
            .padding(.bottom, 8)
        }
        .ignoresSafeArea()
    }
}
