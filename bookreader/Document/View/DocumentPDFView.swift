//
//  DocumentView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-11-08.
//

import SwiftUI
import PDFKit

struct DocumentPDFView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()

        pdfView.document = PDFDocument(url: self.url)
        pdfView.displaysPageBreaks = false
        pdfView.pageBreakMargins = .zero
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal

        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        // Update the view if needed (If you change the pdf)
    }
}
