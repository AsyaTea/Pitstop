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
    
    var categories = ["Category","Day","Odometer","Repeat"]
    
    //To dismiss the modal
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView{
            VStack {
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
                                .padding(.leading,5)
                            Spacer()
                        }
                        
                    }
                }
                
                Button("Save"){
                    //ACTION
                }.buttonStyle(SaveButton())
                
               
            }
            .navigationTitle(
                Text("New report").font(Typography.headerM)
            )
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
                    }).accentColor(Palette.greyHard)
            )
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
