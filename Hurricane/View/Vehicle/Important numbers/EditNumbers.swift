//
//  EditNumbers.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 10/06/22.
//

import SwiftUI


struct EditNumbers: View {
    
    
    @FocusState var focusedField: FocusFieldNumbers?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var dataVM : DataViewModel
    
    @State var numberToEdit : NumberState
    var isDisabled: Bool {
        return numberToEdit.title.isEmpty || numberToEdit.telephone.isEmpty
    }
    
    var body: some View {
        ZStack{
            Palette.greyBackground.ignoresSafeArea()
            VStack(spacing:20){
                TextField("Contact name", text: $numberToEdit.title)
                    .disableAutocorrection(true)
                    .focused($focusedField,equals: .numberTitle)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .numberTitle ? Palette.greyLight :Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .numberTitle ? Palette.black :Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $numberToEdit.title))
                    .onSubmit {
                        focusedField = .number
                    }
                
                TextField("Number", text: $numberToEdit.telephone)
                    .disableAutocorrection(true)
                    .keyboardType(.numberPad)
                    .focused($focusedField,equals: .number)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .number ? Palette.greyLight :Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .number ? Palette.black :Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $numberToEdit.telephone))
                    .onSubmit {
                        focusedField = nil
                    }
                
                Spacer()
            }
            .padding(.top,40)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("arrowLeft")
                    })
                    .accentColor(Palette.greyHard),
                trailing:
                    Button(action: {
                        do {
                            try dataVM.updateNumber(numberToEdit)
                        }
                        catch{
                            print(error)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                            .font(Typography.headerM)
                    }
                          )
                    .disabled(isDisabled)
                    .opacity(isDisabled ? 0.6 : 1)
            )
            .toolbar{
                ToolbarItem(placement: .principal) {
                    Text("Edit contact")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
        }
    }
}

//struct EditNumbers_Previews: PreviewProvider {
//    static var previews: some View {
//        EditNumbers()
//    }
//}
