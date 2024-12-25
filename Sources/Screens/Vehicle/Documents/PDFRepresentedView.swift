//
//  PDFRepresentedView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/06/22.
//

import PDFKit
import SwiftUI

struct PDFRepresentedView: UIViewRepresentable {
    let url: URL

    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context _: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true // Automatically scales content to fit the view

        pdfView.document = PDFDocument(url: url)

        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context _: Context) {
        pdfView.document = PDFDocument(url: url)
    }
}
