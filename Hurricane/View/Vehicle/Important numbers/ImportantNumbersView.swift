//
//  ImportantNumbersView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 14/05/22.
//

import SwiftUI

struct ImportantNumbersView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject var homeVM : HomeViewModel
    @StateObject var dataVM : DataViewModel
    
    var body: some View {
        
        ZStack{
            Palette.greyBackground.edgesIgnoringSafeArea(.all)
                
            VStack{
                HStack{
                    Button(action: {
                        homeVM.resetAlertFields()
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                            .foregroundColor(Palette.greyHard)
                    })
                    .padding(.leading,20)
                    Spacer()
                    Text("Useful contacts")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
//                        .frame(alignment: .center)
                    Spacer(minLength: 150)

                }
                .padding(.vertical,15)
                
                VStack(spacing: 16){
                    ForEach(dataVM.numberList, id:\.self){ number in
                        NumberCardView(title: number.title, number: number.telephone)
                    }
                    Spacer()
                }
                .padding(.vertical,20)
                Button(action: {
                    homeVM.showAlertNumbersInside.toggle()
                }, label: {
                    BlackButton(text: "Add new contact", color: Palette.black)
                })
               
            }
            .overlay(
                ZStack{
                    homeVM.showAlertNumbersInside ? Color.black.opacity(0.4) : Color.clear
                }.ignoresSafeArea()
            )
            if(homeVM.showAlertNumbersInside){
                Spacer()
                AlertAddNumbersInside(homeVM: homeVM,dataVM: dataVM)
                Spacer()
            }

        }.ignoresSafeArea(.keyboard)
       
        
    }
    
}

struct NumberCardView: View {
    
    var title: String
    var number: String
    
    var body: some View {
        ZStack{
            Rectangle()
                .cornerRadius(12)
                .foregroundColor(Palette.greyBackground)
                .shadowGrey()
            HStack{
                VStack(alignment: .leading,spacing: 5){
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

//struct ImportantNumbersView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImportantNumbersView()
//    }
//}
