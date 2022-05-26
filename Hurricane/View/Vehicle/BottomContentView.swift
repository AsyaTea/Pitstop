//
//  BottomContentView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 14/05/22.
//

import SwiftUI

struct BottomContentView: View {
    
    @ObservedObject var homeVM : HomeViewModel
    @StateObject var categoryVM = CategoryViewModel()
    @State private var viewAllNumbers = false
    @State private var viewAllDocuments = false
  
    @State private var showingOptions = false
    
    @StateObject var dataVM : DataViewModel
    
    var body: some View {
        VStack(spacing: 0){
            
            TitleSectionComponent(sectionTitle: "Last events",binding: $viewAllDocuments)
                .padding()
                .padding(.top,10)
                .padding(.bottom,-10)
            ForEach(dataVM.expenseList.reversed().prefix(3),id:\.self) { expense in
                categoryComponent(categoryName: categoryVM.defaultCategory.label, date: expense.date, cost: String(expense.price),color: categoryVM.defaultCategory.color, icon: categoryVM.defaultCategory.icon)
                
            }
            //MARK: TO FIX
            .onAppear{
                categoryVM.selectedCategory = dataVM.expenseList.last?.category ?? 0
            }
            
            TitleSectionComponent(sectionTitle: "Documents", binding: $viewAllDocuments)
                .padding()
                .padding(.top,10)
                .padding(.bottom,-10)
            
            ScrollView(.horizontal,showsIndicators: false){
                VStack {
                    Spacer(minLength: 12)
                    HStack{
                        Button(action: {
                            
                        }, label: {
                            documentComponent(title: "Driving license")
                        })
                        Button(action: {
                            
                        }, label: {
                            addComponent(title: "Add document")
                        })
                        
                    }
                    Spacer(minLength: 16)
                }
                
            }
            .safeAreaInset(edge: .trailing, spacing: 0) {
                Spacer()
                    .frame(width: 16)
            }
            .safeAreaInset(edge: .leading, spacing: 0) {
                Spacer()
                    .frame(width: 16)
            }
            
            TitleSectionComponent(sectionTitle: "Important numbers", binding: $viewAllNumbers)
                .padding()
                .padding(.top,10)
                .padding(.bottom,-10)
            
            //MARK: IMPORTANT NUMBERS
            ScrollView(.horizontal,showsIndicators: false){
                VStack {
                    Spacer(minLength: 12)
                    HStack{
                        Button(action: {
                            UIApplication.shared.open(URL(string: "tel://32994")!)
                        }, label: {
                            importantNumbersComponent(title: "Service", number: "366 4925454")
                        })
                        
                        Button(action: {
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                withAnimation(.easeInOut){
                                    homeVM.showAlertNumbers.toggle()
                                }
                            }
                        }, label: {
                            addComponent(title: "Add number")
                        })
                        
                    }
                    Spacer(minLength: 16)
                }
                
            }
            .safeAreaInset(edge: .trailing, spacing: 0) {
                Spacer()
                    .frame(width: 16)
            }
            .safeAreaInset(edge: .leading, spacing: 0) {
                Spacer()
                    .frame(width: 16)
            }
            
            //Trick for scroll space, if you remove this you will see the problem
            Text("")
                .padding(.vertical,55)
            Spacer()
            
        }
     
        .fullScreenCover(isPresented: $viewAllNumbers){ImportantNumbersView(homeVM: homeVM)}
        .fullScreenCover(isPresented: $viewAllDocuments){WorkInProgress()}
        
    }
    
    @ViewBuilder
    func categoryComponent(categoryName : String, date: Date, cost : String, color: Color, icon : String) -> some View {
        
        let formatted = date.formatDate()
        
        HStack{
            ZStack{
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(color)
                Image(icon)
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            VStack(alignment: .leading){
                Text(categoryName)
                    .foregroundColor(Palette.black)
                    .font(Typography.headerS)
                Text(formatted)
                    .foregroundColor(Palette.greyMiddle)
                    .font(Typography.TextM)
                
            }
            Spacer()
            VStack{
                Text("–$ \(cost)")
                    .foregroundColor(Palette.greyHard)
                    .font(Typography.headerS)
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical,10)
        
    }
    
    
    @ViewBuilder
    func documentComponent(title: String) -> some View {
        ZStack{
            Rectangle()
                .cornerRadius(8)
                .frame(width: UIScreen.main.bounds.width * 0.38, height: UIScreen.main.bounds.height * 0.13)
                .foregroundColor(Palette.white)
                .shadowGrey()
            VStack(alignment: .leading, spacing: 40){
                ZStack{
                    Circle()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Palette.greyLight)
                    Image("documents")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(Palette.black)
                }
                Text(title)
                    .foregroundColor(Palette.black)
                    .font(Typography.ControlS)
            }
            .padding(.leading,-28)
            .padding(.top,-2)
        }
    }
    
    @ViewBuilder
    func importantNumbersComponent(title: String, number: String) -> some View {
        ZStack{
            Rectangle()
                .cornerRadius(8)
                .frame(width: UIScreen.main.bounds.width * 0.38, height: UIScreen.main.bounds.height * 0.13)
                .foregroundColor(Palette.white)
                .shadowGrey()
            VStack(alignment: .leading, spacing: 22){
                ZStack{
                    Circle()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Palette.greyLight)
                    Image("Service")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(Palette.black)
                }
                VStack(alignment: .leading,spacing:3){
                    Text(title)
                        .foregroundColor(Palette.black)
                        .font(Typography.ControlS)
                    Text(number)
                        .foregroundColor(Palette.greyMiddle)
                        .font(Typography.TextM)
                }
            }
            .padding(.leading,-34)
            .padding(.top,-2)
        }
    }
    
    @ViewBuilder
    func addComponent(title : String) -> some View {
        ZStack{
            Rectangle()
                .cornerRadius(8)
                .frame(width: UIScreen.main.bounds.width * 0.38, height: UIScreen.main.bounds.height * 0.13)
                .foregroundColor(Palette.white)
                .shadowGrey()
            VStack(alignment: .center, spacing: 10){
                Image("plus")
                    .foregroundColor(Palette.greyMiddle)
                Text(title)
                    .foregroundColor(Palette.greyMiddle)
                    .font(Typography.ControlS)
            }
        }
    }
}

//struct BottomContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomContentView()
//        
//    }
//}

struct TitleSectionComponent : View {
    
    var sectionTitle : String
    @Binding var binding : Bool
    
    
    var body: some View {
        HStack{
            Text(sectionTitle)
                .foregroundColor(Palette.black)
                .font(Typography.headerL)
            Spacer()
            HStack{
                Button(action:{
                    binding.toggle()
                }, label: {
                    Text("View all")
                        .font(Typography.ControlS)
                        .foregroundColor(Palette.greyMiddle)
                    
                })
                
            }
        }
    }
}


