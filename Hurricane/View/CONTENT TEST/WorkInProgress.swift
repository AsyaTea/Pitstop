//
//  WorkInProgress.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//

import SwiftUI

struct WorkInProgress: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var dataVM: DataViewModel

    var body: some View {
        VStack(spacing: 20) {
            Image("bestBoy")
                .resizable()
                .scaledToFit()
            Text("Go away we are working!")
                .font(Typography.headerXL)
            Spacer()
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Go back")
                    .font(Typography.headerL)

            })
            Button(action: {
                dataVM.removeAllDocuments()
            }, label: {
                Text("Delete all documents")
                    .font(Typography.headerL)

            })
            Spacer()
        }
    }
}
