//
//  DocumentModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//

import Foundation
import CoreData
import UIKit

struct DocumentState: Hashable {
//    var image = UIImage()
    var title: String = ""
    var url : URL?
    var documentID: NSManagedObjectID?
    var bookmark: Data?
}

struct DocumentViewModel : Hashable {
    let document: Document
    
    var title: String {
        return document.title ?? ""
    }
    
    var url: URL {
        return document.url ?? URL(fileURLWithPath: "")
    }
    
    var documentID: NSManagedObjectID {
        return document.objectID
    }
    
    var bookmark: Data {
        return document.bookmark ?? Data()
    }
}

extension DocumentState {
    
    static func fromDocumentViewModel(vm:DocumentViewModel ) -> DocumentState{
        var documentS = DocumentState()
        documentS.title = vm.title
        documentS.url = vm.url
        documentS.documentID = vm.documentID
        documentS.bookmark = vm.bookmark
        return documentS
    }
}

