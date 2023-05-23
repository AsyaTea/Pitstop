//
//  ButtonStyle.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 23/05/23.
//

import SwiftUI

struct Primary: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: 48)
            .frame(height: 48)
            .background(isEnabled ? Palette.black : Palette.greyInput)
            .cornerRadius(43)
            .font(Typography.ControlS)
            .foregroundColor(Palette.white)
            .padding(.horizontal, 16)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct Secondary: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: 48)
            .frame(height: 48)
            .background(isEnabled ? Palette.white : Palette.greyInput)
            .cornerRadius(43)
            .font(Typography.ControlS)
            .foregroundColor(Palette.black)
            .padding(.horizontal, 16)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct ButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            Button("Primary") {}
                .buttonStyle(Primary())
                .disabled(false)
            Button("Secondary") {}
                .buttonStyle(Secondary())
                .disabled(false)
            Spacer()
        }
        .background(Palette.greyHard)
    }
}
