//
//  StatsView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct StatsView: View {
   
    @State private var pickerTabs = ["Overview", "Cost", "Fuel", "Odometer"]
    @State var pickedTab = ""
    var body: some View {
        VStack{
            HStack{
                HStack {
                    Text("Analytics")                    
                        .fontWeight(.bold)
                        .font(Typography.headerXL)
                }
                .frame(alignment: .topLeading)
                .padding()
                Spacer()                
                ZStack{
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(.white)
                    Text("Per month")
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                }
                .frame(width: 80, height: 25, alignment: .center)
                
                Button {
                    print("Bell is tapped")
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 100)
                            .frame(width: 25, height: 25, alignment: .center)
                            .foregroundColor(.white)
                        Image(systemName: "bell")
                            .foregroundColor(.black)
                            .font(.subheadline)
                    }
                }
                //List
            }
            .frame(height: 30)
            .padding()
            
            CostsListView()
        }
        .overlay(content: {
            CustomSegmentedPicker()
        })
        .background(Palette.greyLight)
        
    }
    
    func CustomSegmentedPicker() -> some View{
        HStack(spacing:10) {
            ForEach(pickerTabs,id:\.self){ tab in
                Text(tab)
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .font(Typography.headerS)
                    .foregroundColor(Palette.black)
//                    .background {
//                        if pickedTab == tab {
//                            Capsule()
//                                .fill(Palette.greyLight)
//                                .matchedGeometryEffect(id: "pickerTab", in: animation)
//                        }
//                    }
                    .containerShape(Capsule())
                    .onTapGesture {
//                        withAnimation(.easeInOut){                           
//                            let haptic = UIImpactFeedbackGenerator(style: .soft)
//                            haptic.impactOccurred()
                        }
                    }
            }
        }
    }
    

}

struct CostsListView: View {
    @State var value = "$ 20"
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Costs")
                        .font(Typography.headerL)
                    Spacer()
                    Text("$ 2089")
                        .fontWeight(.semibold)
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
               

                HStack{
                    ListCategoryComponent(title: "Fuel", iconName: "fuelType", color: Palette.colorYellow)
                    Spacer()
                    Text(value)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.greyHard)
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                HStack{
                    ListCategoryComponent(title: "Mainteinance", iconName: "maintanance", color: Palette.colorGreen)
                    Spacer()
                    Text(value)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.greyHard)
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                HStack{
                    ListCategoryComponent(title: "Insurance", iconName: "Insurance", color: Palette.colorOrange)
                    Spacer()
                    Text(value)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.greyHard)
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                HStack{
                    ListCategoryComponent(title: "Tolls", iconName: "Tolls", color: Palette.colorOrange)
                    Spacer()
                    Text(value)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.greyHard)
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                HStack{
                    ListCategoryComponent(title: "Fines", iconName: "fines", color: Palette.colorOrange)
                    Spacer()
                    Text(value)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.greyHard)
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                HStack{
                    ListCategoryComponent(title: "Parking", iconName: "Parking", color: Palette.colorViolet)
                    Spacer()
                    Text(value)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.greyHard)
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                HStack{
                    ListCategoryComponent(title: "Other", iconName: "Other", color: Palette.colorViolet)
                    Spacer()
                    Text(value)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.greyHard)
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                
                
            }
            
            .padding(2)
            Section {
                FuelListView()
                    .padding(2)
            }
        }
    }
}

struct FuelListView : View {
    var body: some View {
        
        HStack {
            Text("Fuel")
                .font(Typography.headerL)
            Spacer()
            Text("8,71L/100 Km")
                .fontWeight(.semibold)
                .font(Typography.headerM)
        }
        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
        ListCostsAttributes(title: "Category", value: "$ 20")
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Fuel", value: "$ 1.564")
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Refuels per month", value: "13")
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Average days/refuel", value: "26")
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))


    }
}

struct ListCostsAttributes: View {
    var title : String
    var value : String
    var body: some View {
        HStack{
            Text(title)
                .font(Typography.headerM)
            Spacer()
            Text(value)
                .foregroundColor(Palette.greyHard)
        }
        
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
