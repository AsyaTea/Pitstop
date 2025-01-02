//
//  SegmentedPicker.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 02/01/25.
//

import SwiftUI

struct SegmentedPicker<T>: View where
    T: Hashable & CaseIterable & RawRepresentable & Identifiable,
    T.RawValue == String {
    @Namespace var animation
    @Binding var currentTab: T
    var onTap: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            ForEach(Array(T.allCases), id: \.id) { tab in
                tabView(for: tab)
            }
        }
    }

    private func tabView(for tab: T) -> some View {
        Text(tab.rawValue.capitalized)
            .fixedSize()
            .frame(maxWidth: .infinity)
            .padding(10)
            .font(Typography.headerS)
            .foregroundColor(currentTab == tab ? Palette.black : Palette.black.opacity(0.7))
            .background {
                if currentTab == tab {
                    Capsule()
                        .fill(Palette.greyLight)
                        .matchedGeometryEffect(id: "pickerTab", in: animation)
                }
            }
            .containerShape(Capsule())
            .onTapGesture {
                withAnimation(.easeInOut) {
                    currentTab = tab
                    let haptic = UIImpactFeedbackGenerator(style: .soft)
                    haptic.impactOccurred()
                }
                onTap()
            }
    }
}

#Preview {
    @Previewable @State var tabs: AddReportTabs = .expense
    SegmentedPicker(currentTab: $tabs, onTap: {})
}
