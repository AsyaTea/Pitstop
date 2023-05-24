//
//  StatsView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct AnalyticsOverviewView: View {
    @StateObject var statisticsVM = StatisticsViewModel()
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var utilityVM: UtilityViewModel

    @State private var pickerTabs = [String(localized: "Overview"), String(localized: "Costs"), String(localized: "Fuel"), String(localized: "Odometer")]
    @State var pickedTab = ""

    @Namespace var animation

    var body: some View {
        if categoryVM.expenseList.isEmpty {
            ZStack {
                Palette.white.ignoresSafeArea()
                VStack {
                    Spacer()
                    GifView("loadingStats")
                        .frame(width: 300, height: 300)
                    Text(String(localized: "No data to show"))
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                    Spacer()
                }
            }
        }
        VStack {
            AnalyticsHeaderView(statisticsVM: statisticsVM, categoryVM: categoryVM, dataVM: dataVM)
                .padding(10)
                .frame(height: 40)

            if categoryVM.currentPickerTab == String(localized: "Overview") {
                OverviewView(dataVM: dataVM, categoryVM: categoryVM, utilityVM: utilityVM)
            } else if categoryVM.currentPickerTab == String(localized: "Costs") {
                AnalyticsCostView(categoryVM: categoryVM, dataVM: dataVM, utilityVM: utilityVM)
            } else if categoryVM.currentPickerTab == String(localized: "Fuel") {
                AnalyticsFuelView(categoryVM: categoryVM, utilityVM: utilityVM)
            } else {
                AnalyticsOdometerView(categoryVM: categoryVM, dataVM: dataVM, utilityVM: utilityVM)
            }
        }
        .background(Palette.greyBackground)
        .overlay(content: {
            VStack {
                Spacer()
//                CustomSegmentedPicker()
//                    .padding(.horizontal)
//                    .padding(.vertical, 12)
//                    .background(.ultraThinMaterial)
            }
        })
        .background(Palette.greyLight)
    }

    // TODO: TYPE CHECK EXPRESSION ERROR
    /*    func CustomSegmentedPicker() -> some View {
         ZStack {
             HStack(alignment: .center, spacing: 10) {
                 ForEach(pickerTabs, id: \.self) { tab in
                     if categoryVM.currentPickerTab == tab {
                         Text(tab)
                             .fixedSize()
                             .frame(maxWidth: .infinity)
                             .padding(10)
                             .font(Typography.headerXS)
                             .foregroundColor(Palette.white)
                             .background {
                                 if categoryVM.currentPickerTab == tab {
                                     Capsule()
                                         .fill(Palette.black)
                                         .matchedGeometryEffect(id: "pickerTab", in: animation)
                                 }
                             }
                             .containerShape(Capsule())
                             .contentShape(Capsule())
                             .onTapGesture {
                                 withAnimation(.easeInOut) {
                                     categoryVM.currentPickerTab = tab
                                     let haptic = UIImpactFeedbackGenerator(style: .soft)
                                     haptic.impactOccurred()
                                 }
                             }
                     } else {
                         Text(tab)
                             .fixedSize()
                             .frame(maxWidth: .infinity)
                             .padding(10)
                             .font(Typography.headerXS)
                             .foregroundColor(Palette.black)
                             .background {
                                 if categoryVM.currentPickerTab == tab {
                                     Capsule()
                                         .fill(Palette.black)
                                         .matchedGeometryEffect(id: "pickerTab", in: animation)
                                 }
                             }
                             .containerShape(Capsule())
                             .contentShape(Capsule())
                             .onTapGesture {
                                 withAnimation(.easeInOut) {
                                     categoryVM.currentPickerTab = tab
                                     let haptic = UIImpactFeedbackGenerator(style: .soft)
                                     haptic.impactOccurred()
                                 }
                             }
                     }
                 }
             }
             .padding(.horizontal, 3)
         }
     } */
}

// MARK: Overview page

struct OverviewView: View {
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var utilityVM: UtilityViewModel

    init(dataVM: DataViewModel, categoryVM: CategoryViewModel, utilityVM: UtilityViewModel) {
        self.dataVM = dataVM
        self.categoryVM = categoryVM
        self.utilityVM = utilityVM
    }

    var body: some View {
        CustomList {
            Section {
                CostsListView(utilityVM: utilityVM, categoryVM: categoryVM, dataVM: dataVM)
            }

            Section {
                FuelListView(categoryVM: categoryVM, utilityVM: utilityVM)
                    .padding(2)
            }
            Section {
                OdometerCostsView(categoryVM: categoryVM, dataVM: dataVM, utilityVM: utilityVM, showTotalOdometer: true)
                    .padding(2)
            }
            Section {}
        }
    }
}

// MARK: Costs List Section

struct CostsListView: View {
    @ObservedObject var utilityVM: UtilityViewModel
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var dataVM: DataViewModel

    var body: some View {
        Section {
            HStack {
                Text("Costs")
                    .font(Typography.headerL)
                Spacer()
                let formattedCost = String(format: "%.0f", dataVM.totalExpense)
                Text("\(formattedCost) \(utilityVM.currency)")
                    .fontWeight(.semibold)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            ForEach(categoryVM.categories, id: \.self) { category in
                HStack {
                    CategoryRow(title: category.name, iconName: category.icon, color: category.color)
                    Spacer()
                    Text(String(category.totalCosts))
                        .font(Typography.headerM)
                        .foregroundColor(Palette.greyHard)
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            }
        }

        .padding(2)
    }
}

// MARK: Fuel data Section

struct FuelListView: View {
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var utilityVM: UtilityViewModel
    var body: some View {
        HStack {
            Text("Fuel")
                .font(Typography.headerL)
            Spacer()
            let formattedCost = String(format: "%.2f", categoryVM.fuelEff)
            Text("\(formattedCost) L/100 \(utilityVM.unit)")
                .fontWeight(.semibold)
                .font(Typography.headerM)
        }
        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

        ListCostsAttributes(title: "Expense", value: String(categoryVM.fuelTotal))
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Average price", value: "\(String(categoryVM.avgPrice)) \(utilityVM.currency)/L")
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Refuels", value: String(categoryVM.refuelsPerTime))

            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Average days/refuel", value: String(categoryVM.avgDaysRefuel))
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
    }
}

// MARK: Odometer Section

struct OdometerCostsView: View {
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var utilityVM: UtilityViewModel
    var showTotalOdometer: Bool

    var body: some View {
        if showTotalOdometer {
            HStack {
                Text("Odometer")
                    .font(Typography.headerL)
                Spacer()
                Text("\(String(Int(dataVM.currentVehicle.first?.odometer ?? 0))) km")
                    .fontWeight(.semibold)
                    .font(Typography.headerM)
            }
        }
        let formattedAvgOdo = String(format: "%.0f", categoryVM.avgOdometer)
        let formattedEstimatedOdo = String(format: "%.0f", categoryVM.estimatedOdometerPerYear)
        ListCostsAttributes(title: "Average", value: " \(formattedAvgOdo) \(utilityVM.unit)" + NSLocalizedString("/day", comment: ""))
        ListCostsAttributes(title: "Month Total", value: String(categoryVM.odometerTotal))
        ListCostsAttributes(title: "Estimated km/year", value: "\(formattedEstimatedOdo) \(utilityVM.unit)")
    }
}

// MARK: List row

struct ListCostsAttributes: View {
    var title: LocalizedStringKey
    var value: String
    var body: some View {
        HStack {
            Text(title)
                .font(Typography.headerM)
            Spacer()
            Text(value)
                .foregroundColor(Palette.greyHard)
        }
    }
}

// MARK: Analytics Header

struct AnalyticsHeaderView: View {
    @ObservedObject var statisticsVM: StatisticsViewModel
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var dataVM: DataViewModel
    @State private var selectedTimeFrame = String(localized: "Per month")
    var body: some View {
        HStack {
            HStack {
                Text("Analytics")
                    .font(Typography.headerXL)
                    .padding(.leading, 5)
            }
            .frame(alignment: .topLeading)

            Spacer()

            HStack {
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
                                print("tag is  \(tag)")
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

                //               MARK: - DOWNLOAD DATA BUTTON

                ZStack {
                    Button(action: {}, label: {
                        ZStack {
                            Circle()
                                .foregroundColor(Palette.white)
                                .frame(width: UIScreen.main.bounds.width * 0.09, height: UIScreen.main.bounds.height * 0.04)
                                .shadowGrey()
                            Image("download")
                                .frame(alignment: .center)
                                .padding()
                        }
                    })
                }
                .padding()
            }
            .padding(.top, 2)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading:
            Text("Analytics")
                .foregroundColor(Palette.black)
                .font(Typography.headerXL)
                .padding(.top, 15)
        )
        .padding(.top)
    }
}

//
// struct StatsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnalyticsOverviewView(dataVM: DataViewModel(), utilityVM: UtilityViewModel())
//    }
// }
