//
//  AnalyticsOdometer.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 23/01/23.
//

import Charts
import SwiftUI

struct AnalyticsOdometer: View {
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var utilityVM: UtilityViewModel

    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(String(Int(dataVM.currentVehicle.first?.odometer ?? 0))) km")
                            .font(Typography.headerL)
                        Text(String(localized: "Odometer"))
                            .font(Typography.headerS)
                            .foregroundColor(Palette.greyMiddle)
                        Chart {
                            ForEach(categoryVM.odometerGraphData2) { data in
                                LineMark(x: .value("Date", data.date),
                                         y: .value("Value", data.value))
                                    .lineStyle(StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                                    .foregroundStyle(Palette.blueLine)
                                    .interpolationMethod(.catmullRom)
                                AreaMark(x: .value("Value", data.date),
                                         yStart: .value("Min", 0),
                                         yEnd: .value("Max", data.value))
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(
                                        LinearGradient(gradient: Gradient(colors: [Palette.blueLine, .clear]),
                                                       startPoint: .top,
                                                       endPoint: .bottom)
                                    )
                                    .opacity(0.3)
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading) { _ in
                                AxisValueLabel()
                            }
                        }
                        .chartXAxis {
                            AxisMarks(position: .bottom) { _ in
                                AxisValueLabel()
                            }
                        }
                        .padding(.top, 20)
                        .frame(height: 250)
                    }
                    .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                }
                .listRowSeparator(.hidden)

                Section {
                    OdometerCostsView(categoryVM: categoryVM,
                                      dataVM: dataVM,
                                      utilityVM: utilityVM,
                                      showTotalOdometer: false)
                        .listRowInsets(EdgeInsets(
                            top: 14, leading: 16, bottom: 14, trailing: 16
                        )
                        )
                        .padding(4)
                }
                .listRowSeparatorTint(Palette.separatorColor)
            }
            .scrollContentBackground(.hidden)
        }
        .background(Palette.greyLight)
    }
}

struct AnalyticsOdometer_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsOdometer(categoryVM: CategoryViewModel(), dataVM: DataViewModel(), utilityVM: UtilityViewModel())
    }
}
