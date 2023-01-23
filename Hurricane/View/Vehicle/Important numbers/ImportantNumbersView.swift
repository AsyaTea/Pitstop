//
//  ImportantNumbersView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 14/05/22.
//

import SwiftUI

struct ImportantNumbersView: View {
    @Environment(\.presentationMode) private var presentationMode

    @ObservedObject var homeVM: HomeViewModel
    @ObservedObject var dataVM: DataViewModel

    @State private var showEdit = false

    var body: some View {
        NavigationView {
            ZStack {
                Palette.greyBackground.edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            ForEach(dataVM.numberList, id: \.self) { number in
                                NavigationLink(
                                    destination: EditNumbers(dataVM: dataVM, numberToEdit: NumberState.fromNumberViewModel(vm: number))
                                ) {
                                    NumberCardView(title: number.title, number: number.telephone)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    Spacer()
//                        Button(action: {
//                            homeVM.showAlertNumbersInside.toggle()
//                            homeVM.interactiveDismiss.toggle()
//                        }, label: {
//                            BlackButton(text: "Add new contact", color: Palette.black)
//                        })
                }
                .overlay(
                    homeVM.showAlertNumbersInside ? Color.black.opacity(0.4) : Color.clear
                )

                if homeVM.showAlertNumbersInside {
                    Spacer()
                    AlertAddNumbersInside(homeVM: homeVM, dataVM: dataVM)
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                Button(action: {
                    homeVM.resetAlertFields()
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .font(Typography.headerM)
                })
                .accentColor(Palette.greyHard)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Useful contacts")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct NumberCardView: View {
    var title: String
    var number: String

    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(12)
                .foregroundColor(Palette.white)
                .shadowGrey()
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(Typography.ControlS)
                        .foregroundColor(Palette.black)
                    Text(number)
                        .font(Typography.TextM)
                        .foregroundColor(Palette.greyMiddle)
                }
                .padding()
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.075, alignment: .center)
    }
}

// struct ImportantNumbersView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImportantNumbersView()
//    }
// }
