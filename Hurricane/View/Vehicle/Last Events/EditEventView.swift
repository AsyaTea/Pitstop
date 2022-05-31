//
//  EditEventView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 31/05/22.
//

import SwiftUI

struct EditEventView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var utilityVM : UtilityViewModel
    @StateObject var dataVM : DataViewModel
    var category : Category
    
    var body: some View {
        NavigationView{
            VStack{
                EventListFields(utilityVM: utilityVM, category: category)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                            .font(Typography.headerM)
                    })
                    .accentColor(Palette.greyHard),
                trailing:
                    Button(action: {
//                        do {
//                            try dataVM.updateExpense(utilityVM.expenseToEdit)
//                        }
//                        catch{
//                            print(error)
//                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                            .font(Typography.headerM)
                    })
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(category.label)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
            .overlay(
                VStack{
                    Spacer(minLength: UIScreen.main.bounds.size.height * 0.78)
                    Button(action: {
                        
                    }, label: {
                        DeleteButton()
                    })
                    Spacer()
                }
            )
        }
    }
}


struct DeleteButton : View {
    var body: some View {
        ZStack{
            Capsule(style: .continuous)
                .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055, alignment: .center)
                .foregroundColor(Palette.black)
            HStack{
                Spacer()
                Image("deleteIcon")
                    .resizable()
                    .foregroundColor(Palette.white)
                    .frame(width: 14, height: 14)
                Text("Delete report")
                    .foregroundColor(Palette.white)
                    .font(Typography.ControlS)
                Spacer()
            }
        }
    }
}

struct EventListFields: View {
    
    @StateObject var utilityVM : UtilityViewModel
    var category : Category
    
    var body: some View {
        List{
            //MARK: CATEGORY FUEL
            HStack{
                ListCategoryComponent(title: "Amount", iconName: "other", color: Palette.colorViolet)
                Spacer()
                TextField("100", value: $utilityVM.expenseToEdit.price,formatter: NumberFormatter())
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .keyboardType(.decimalPad)
                    .fixedSize(horizontal: true, vertical: true)
//                    .focused(focusedField, equals: .odometer)
                   
                Text(utilityVM.currency)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            HStack{
                ListCategoryComponent(title: "Category", iconName: "category", color: Palette.colorYellow)
                Spacer()
                Text(category.label)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            HStack{
                ListCategoryComponent(title: "Day", iconName: "day", color: Palette.colorGreen)
                Spacer()
                Text("Today")
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            HStack{
                ListCategoryComponent(title: "Price/Liter", iconName: "priceLiter", color: Palette.greyLight)
                Spacer()
                Text("1.70")
                
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            HStack{
                ListCategoryComponent(title: "Liters", iconName: "liters", color: Palette.greyLight)
                Spacer()
                Text("20")
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            HStack{
                ListCategoryComponent(title: "Note", iconName: "note", color: Palette.greyLight)
                Spacer()
                TextField("Lorem Ipsum", text: $utilityVM.expenseToEdit.note)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .fixedSize(horizontal: true, vertical: true)
//                    .focused(focusedField, equals: .odometer)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
        }
    }
}

//struct EditEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditEventView()
//    }
//}
