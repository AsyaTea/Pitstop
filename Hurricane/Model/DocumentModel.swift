//
//  DocumentModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//

import CoreData
import Foundation
import UIKit

struct DocumentState: Hashable {
//    var image = UIImage()
    var title: String = ""
    var url: URL?
    var documentID: NSManagedObjectID?
    var bookmark: Data?
}

struct DocumentViewModel: Hashable {
    let document: Document

    var title: String {
        document.title ?? ""
    }

    var url: URL {
        document.url ?? URL(fileURLWithPath: "")
    }

    var documentID: NSManagedObjectID {
        document.objectID
    }

    var bookmark: Data {
        document.bookmark ?? Data()
    }
}

extension DocumentState {
    static func fromDocumentViewModel(vm: DocumentViewModel) -> DocumentState {
        var documentS = DocumentState()
        documentS.title = vm.title
        documentS.url = vm.url
        documentS.documentID = vm.documentID
        documentS.bookmark = vm.bookmark
        return documentS
    }
}
