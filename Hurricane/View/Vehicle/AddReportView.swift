//
//  AddReportView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI



struct AddReportView: View {
    
    init() {
        //  Change list background color
        UITableView.appearance().separatorStyle = .none
        //       UITableViewCell.appearance().backgroundColor = .green
        UITableView.appearance().backgroundColor = UIColor(Palette.greyBackground)
    }
    
    @StateObject var utilityVM : UtilityViewModel = .init()
    
    //MARK: TODO COLLEGARE VAR
    var categories = ["Category","Day","Odometer","Repeat"]
    @State private var price : String = ""
    var currency = "$"
    
    @State private var pickerTabs = ["Expense", "Odometer", "Reminder"]
    
    //Matching geometry namespace
    @Namespace var animation
    
    //Focusn keyboard
    @FocusState private var focusedField: FocusField?
    enum FocusField: Hashable {
        case field
    }
    
    //To dismiss the modal
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView{
            VStack {
                
                //MARK: Price textField
                HStack{
                    Spacer()
                    TextField("42",text: $price)
                        .focused($focusedField, equals: .field)
                        .font(Typography.headerXXL)
                        .foregroundColor(Palette.black)
                        .textFieldStyle(.plain)
                        .keyboardType(.decimalPad)
                        .fixedSize(horizontal: true, vertical: true)
                    Text(currency)
                        .font(Typography.headerXXL)
                        .foregroundColor(Palette.black)
                    Spacer()
                }.padding(.top,20)
                
                //MARK: Custom segmented picker
                CustomSegmentedPicker()
                    .padding()
            
                List{
                    ForEach(categories, id:\.self){ category in
                        HStack{
                            ZStack{
                                Circle()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(Palette.colorOrange)
                                Image(systemName: "drop")
                                    .resizable()
                                    .blendMode(.screen)
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.white)
                            }
                            Text(category)
                                .font(Typography.headerM)
                                .foregroundColor(Palette.black)
                                .padding(.leading,5)
                            Spacer()
                        }
                    }
                }
                
                
//                Button("Save"){
//                    presentationMode.wrappedValue.dismiss()
//                }
//                .buttonStyle(SaveButton())
//                .disabled(price.isEmpty)
//                .opacity(price.isEmpty ? 0.6 : 1)
                
                
            }
            .background(Palette.greyBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack{
                            Image(systemName: "chevron.left")
                            Text("Cancel")
                                .font(Typography.headerM)
                        }
                    })
                    .accentColor(Palette.greyHard),
                trailing:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                            Text("Save")
                                .font(Typography.headerM)
                        }
                    )
                    .disabled(price.isEmpty)
                    .opacity(price.isEmpty ? 0.6 : 1)
                    .accentColor(Palette.greyHard)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New report")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
            .onAppear {
                /// Setting the keyboard focus on the price
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {  /// Anything over 0.5 delay seems to work
                    self.focusedField = .field
                }
            }
        }
    }
    
    @ViewBuilder
    func CustomSegmentedPicker() -> some View{
        HStack(spacing:10){
            ForEach(pickerTabs,id:\.self){ tab in
                Text(tab)
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .font(Typography.headerS)
                    .foregroundColor(Palette.black)
                    .background{
                        if utilityVM.currentPickerTab == tab {
                            Capsule()
                                .fill(Palette.greyLight)
                                .matchedGeometryEffect(id: "pickerTab", in: animation)
                        }
                    }
                    .containerShape(Capsule())
                    .onTapGesture {
                        withAnimation(.easeInOut){
                            utilityVM.currentPickerTab = tab
                            
                        }
                    }
            }
        }
    }
    
}

struct AddReportView_Previews: PreviewProvider {
    static var previews: some View {
        AddReportView()
    }
}

struct SaveButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055, alignment: .center)
            .background(Palette.black)
            .foregroundColor(Palette.white)
            .clipShape(Rectangle())
            .cornerRadius(43)
        
    }
}


