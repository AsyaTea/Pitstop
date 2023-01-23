//
//  HomeViewModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 13/05/22.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var offset: CGFloat = 0
    @Published var topEdge: CGFloat = 0
    let maxHeight = UIScreen.main.bounds.height / 3.6

    // Alert numbers
    @Published var showAlertNumbers = false
    @Published var showAlertNumbersInside = false
    @Published var numberTitle = ""
    @Published var number = ""
    @Published var interactiveDismiss = false

    @Published var numberS = NumberState()

    @Published var headerBackgroundColor = Palette.colorViolet
    @Published var headerCardColor = Palette.colorMainViolet

    @Published var COLOR_KEY = "COLOR_KEY"
    @Published var COLOR_KEY_CARD = "COLOR_KEY_CARD"

    private let userDefaults = UserDefaults.standard

    func saveColor(color: Color, key: String) {
        let color = UIColor(color).cgColor

        if let components = color.components {
            userDefaults.set(components, forKey: key)
            print(components)
            print("Color saved")
        }
    }

    func loadColor(key: String) -> Color {
        guard let array = userDefaults.object(forKey: key) as? [CGFloat] else {
            if key == COLOR_KEY {
                return Palette.colorViolet
            } else { return Palette.colorMainViolet }
        }
        let color = Color(.sRGB, red: array[0], green: array[1], blue: array[2], opacity: array[3])

        print(color)
        print("Color loaded")
        return color
    }

    func createNumber() {
        numberS.telephone = number
        numberS.title = numberTitle
    }

    var isDisabled: Bool {
        numberTitle.isEmpty || number.isEmpty
    }

    func resetAlertFields() {
        numberTitle = ""
        number = ""
        showAlertNumbers = false
    }

    func resetAlertFieldsInside() {
        numberTitle = ""
        number = ""
        showAlertNumbersInside = false
    }

    // MARK: FRONTEND FUNCS

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

struct ColorData {
    private var COLOR_KEY = "COLOR_KEY"
    private let userDefaults = UserDefaults.standard

    func saveColor(color: Color) {
        let color = UIColor(color).cgColor

        if let components = color.components {
            userDefaults.set(components, forKey: COLOR_KEY)
            print(components)
            print("Color saved")
        }
    }

    func loadColor() -> Color {
        guard let array = userDefaults.object(forKey: COLOR_KEY) as? [CGFloat] else { return Palette.black }

        let color = Color(.sRGB, red: array[0], green: array[1], blue: array[2], opacity: array[3])

        print(color)
        print("Color loaded")
        return color
    }
}
