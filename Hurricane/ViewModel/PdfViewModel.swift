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
        do{
            var isStale = false
            self.url = try URL(resolvingBookmarkData: documentState.bookmark ?? Data(), bookmarkDataIsStale: &isStale)
            guard !isStale else {
                // Handle stale data here.
                return
            }
        }
        catch let error {
            // Handle the error here.
            print(error)
        }
        
    }
}

