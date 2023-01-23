//
//  DocumentView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 11/06/22.
//

import PDFKit
import SwiftUI

struct DocumentView: View {
    @StateObject var pdfVM: PdfViewModel
    @Environment(\.presentationMode) private var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                PDFKitRepresentedView(pdfVM.url ?? URL(fileURLWithPath: ""))
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
                .accentColor(Palette.greyHard)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(pdfVM.documentState.title)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
        }
    }
}
