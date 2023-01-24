//
//  AnalyticsView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 23/01/23.
//

import SwiftUI

struct AnalyticsView: View {
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var utilityVM: UtilityViewModel
    @State var currentPickerTab: AnalyticsTab = .overview
    @Namespace var animation

    var body: some View {
        NavigationView {
            VStack {
                if currentPickerTab == .overview {
                    OverviewView(dataVM: dataVM, categoryVM: categoryVM, utilityVM: utilityVM)
                } else if currentPickerTab == .costs {
                    AnalyticsCostView(categoryVM: categoryVM, dataVM: dataVM, utilityVM: utilityVM)
                } else if currentPickerTab == .fuel {
                    AnalyticsFuelView(categoryVM: categoryVM, utilityVM: utilityVM)
                } else {
                    AnalyticsOdometer(categoryVM: categoryVM, dataVM: dataVM, utilityVM: utilityVM)
                }
            }
            .background(Palette.greyBackground)
            .overlay(content: {
                VStack {
                    Spacer()
                    customSegmentedPicker()
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial)
                }
            })
            .background(Palette.greyLight)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                Text("Analytics")
                    .foregroundColor(Palette.black)
                    .font(Typography.headerXL),
                trailing:
                trailingTopBarItem()
            )
        }
        .navigationViewStyle(.stack)
    }

    @ViewBuilder
    private func trailingTopBarItem() -> some View {
        HStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .foregroundColor(Palette.white)
                    .cornerRadius(37)
                    .frame(width: 125, height: UIScreen.main.bounds.height * 0.04)
                    .shadowGrey()
                HStack {
                    Menu {
                        Picker(selection: $categoryVM.selectedTimeFrame, label: Text("Time")) {
                            ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                                Text(timeFrame.label)
                                    .tag(timeFrame)
                            }
                        }
                        .onChange(of: categoryVM.selectedTimeFrame) { tag in
                            categoryVM.setSelectedTimeFrame(timeFrame: tag)
                            categoryVM.retrieveAndUpdate(vehicleID: dataVM.currentVehicle.first!.vehicleID)
                        }

                    } label: {
                        HStack {
                            Text(categoryVM.selectedTimeFrame.label)
                                .foregroundColor(Palette.black)
                                .font(Typography.ControlS)
                            Image("arrowDown")
                                .foregroundColor(Palette.black)
                        }
                    }
                    .padding()
                }
            }

            // TODO: IMPLEMENT DOWNLOAD
            ZStack {
                Button(action: {}, label: {
                    ZStack {
                        Circle()
                            .foregroundColor(Palette.white)
                            .frame(width: 35, height: 35)
                            .shadowGrey()
                        Image("download")
                            .frame(alignment: .center)
                            .padding()
                    }
                })
            }
        }
    }

    // TODO: REFACTOR IN GENERIC WAY
    @ViewBuilder
    private func customSegmentedPicker() -> some View {
        ZStack {
            HStack(alignment: .center, spacing: 10) {
                ForEach(AnalyticsTab.allCases, id: \.self) { tab in
                    Text(tab.label)
                        .fixedSize()
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .font(Typography.headerXS)
                        .foregroundColor(currentPickerTab == tab ? Palette.white : Palette.black)
                        .background {
                            if currentPickerTab == tab {
                                Capsule()
                                    .fill(Palette.black)
                                    .matchedGeometryEffect(id: "pickerTab", in: animation)
                            }
                        }
                        .containerShape(Capsule())
                        .contentShape(Capsule())
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                currentPickerTab = tab
                                let haptic = UIImpactFeedbackGenerator(style: .soft)
                                haptic.impactOccurred()
                            }
                        }
                }
            }
            .padding(.horizontal, 3)
        }
    }
}

enum AnalyticsTab: CaseIterable {
    case overview
    case costs
    case fuel
    case odometer

    var label: String {
        switch self {
        case .overview:
            return String(localized: "Overview")
        case .costs:
            return String(localized: "Costs")
        case .fuel:
            return String(localized: "Fuel")
        case .odometer:
            return String(localized: "Odometer")
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView(dataVM: DataViewModel(), categoryVM: CategoryViewModel(), utilityVM: UtilityViewModel())
    }
}
