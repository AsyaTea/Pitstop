//
//  PDFKitView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/06/22.
//

import SwiftUI
import PDFKit


struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL?
    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        if let url = url {
            pdfView.document = PDFDocument(url: url)
        }
        pdfView.autoScales = true
//        pdfView.displayMode = .singlePageContinuous
//        pdfView.maxScaleFactor = 4.0
//        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
        
    }
}
