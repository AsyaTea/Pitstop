//
//  PdfViewModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/06/22.
//

import SwiftUI

class PdfViewModel: ObservableObject {
    @Published var documentState = DocumentState()
    @Published var url: URL?

    func loadBookmark() {
        do {
            var isStale = false
            url = try URL(resolvingBookmarkData: documentState.bookmark ?? Data(), bookmarkDataIsStale: &isStale)
            guard !isStale else {
                // Handle stale data here.
                return
            }
        } catch {
            // Handle the error here.
            print(error)
        }
    }
}
