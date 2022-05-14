//
//  Palette.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import SwiftUI


enum Palette {
    
    static let white = Color(rgb: 0xFFFFFF)
    static let black = Color(rgb: 0x0B0B0B)
    
    static let colorViolet = Color(rgb: 0xC6B3FF)
    static let colorGreen = Color(rgb: 0x8BE8BD)
    static let colorYellow = Color(rgb: 0xF3E390)
    static let colorBlue = Color(rgb: 0x97F1EC)
    static let colorOrange = Color(rgb: 0xF2C888)
    
    static let greyHard = Color(rgb: 0x616161)
    static let greyMiddle = Color(rgb: 0x8A8A8A)
    static let greyInput = Color(rgb: 0xD2D2D2)
    static let greyLight = Color(rgb: 0xF5F5F5)
    static let greyEBEBEB = Color(rgb: 0xEBEBEB)
    static let greyBackground = Color(rgb: 0xFBFBFB)
    
    static let colorVioletLight = Color(rgb: 0x94BCF8)

    static let colorMainBlue = Color(rgb: 0x9FFCF7)
    static let colorMainGreen = Color(rgb: 0x94F3C7)
    static let colorMainYellow = Color(rgb: 0xFCED9D)
    static let colorMainViolet = Color(rgb: 0xFCED9D)
    static let greenHighlight = Color(rgb: 0x37E391)
    static let blueLine = Color(rgb: 0x4761FE)
    
    
    static let testDarkmode = Color(lightRGB: 0xff0000, darkRGB: 0x00ff00)
}

extension View {
    func shadowGrey() -> some View {
        self
            .shadow(color: .black.opacity(0.04) ,radius: 10, x:1 , y: 2)
    }
}

