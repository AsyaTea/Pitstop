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
    
    //Text fields vars
    @State private var price : String = ""
    var currency = "$"
    @State private var odometer : String = ""
    var unit = "km"
    @State private var note : String = ""
    
    //Date
    @State private var date = Date()
    @State private var showDate = false
    private var dateFormater: DateFormatter {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        return dateFormater
    }
    
    @State var calendarId: UUID = UUID()
    
    //Custom picker tabs
    @State private var pickerTabs = ["Expense", "Odometer", "Reminder"]
    
    //List picker categories
    @State private var selectedCategory = "Fuel"
    let categoryTypes = ["Fuel", "Maintenance", "Insurance","Road tax","Tolls","Fines","Parking","Other"]
    
    @State private var selectedRepeat = "Never"
    let repeatTypes = ["Never", "Daily", "Weekdays","Weekends", "Weekly","Monthly","Every 3 Months","Every 6 Months","Yearly"]
    
    //Matching geometry namespace
    @Namespace var animation
    
    //Focusn keyboard
    @FocusState private var focusedField: FocusField?
    enum FocusField: Hashable {
        case price
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
                        .focused($focusedField, equals: .price)
                        .font(Typography.headerXXL)
                        .foregroundColor(Palette.black)
                        .textFieldStyle(.plain)
                        .keyboardType(.decimalPad)
                        .fixedSize(horizontal: true, vertical: true)
                    //                        .onChange(of: focusedField){ new in
                    //                            if(!price.isEmpty){
                    //                            focusedField = nil
                    //                            }
                    //                        }
                    
                    Text(currency)
                        .font(Typography.headerXXL)
                        .foregroundColor(Palette.black)
                    Spacer()
                }.padding(.top,15)
                
                //MARK: Custom segmented picker
                
                CustomSegmentedPicker()
                    .padding(.horizontal,32)
                    .padding(.top, -10.0)
                
                
                List{
                    //MARK: CATEGORY PICKER
                    Picker(selection: $selectedCategory, content: {
                        ForEach(categoryTypes, id: \.self) {
                            Text($0)
                                .font(Typography.headerM)
                        }
                    },label:{
                        HStack{
                            ZStack{
                                Circle()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(Palette.colorYellow)
                                Image("category")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                
                            }
                            Text("Category")
                                .font(Typography.headerM)
                        }
                    })
                    
                    //MARK: ODOMETER
                    HStack{
                        HStack{
                            ZStack{
                                Circle()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(Palette.colorBlue)
                                Image("odometer")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                
                            }
                            Text("Odometer")
                                .font(Typography.headerM)
                                .foregroundColor(Palette.black)
                                .padding(.leading,5)
                            
                            Spacer()
                        }
                        TextField("100",text: $odometer)
                            .font(Typography.headerM)
                            .foregroundColor(Palette.black)
                            .textFieldStyle(.plain)
                            .keyboardType(.decimalPad)
                            .fixedSize(horizontal: true, vertical: true)
                        Text(unit)
                            .font(Typography.headerM)
                            .foregroundColor(Palette.black)
                    }
                    
                    //MARK: REPEAT PICKER
                    Picker(selection: $selectedRepeat, content: {
                        ForEach(repeatTypes, id: \.self) {
                            Text($0)
                                .font(Typography.headerM)
                        }
                    }, label:{
                        HStack{
                            ZStack{
                                Circle()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(Palette.colorViolet)
                                Image("repeat")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                
                            }
                            Text("Repeat")
                                .font(Typography.headerM)
                        }
                    })
                    
                    //MARK: DATE PICKER
                    DatePicker(selection: $date, displayedComponents: [.date]) {
                        HStack{
                            ZStack{
                                Circle()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(Palette.colorGreen)
                                Image("day")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                            }
                            Text("Day")
                                .font(Typography.headerM)
                                .foregroundColor(Palette.black)
                                .padding(.leading,5)
                            Spacer()
                        }
                    }
                    //MARK: NOTE
                    HStack{
                        ZStack{
                            Circle()
                                .frame(width: 32, height: 32)
                                .foregroundColor(Palette.greyLight)
                            Image("note")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        TextField("Note",text: $note)
                            .font(Typography.headerM)
                    }
                }
                .padding(.top,-10)
                
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
                    self.focusedField = .price
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


