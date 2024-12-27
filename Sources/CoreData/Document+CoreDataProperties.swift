//
//  Document+CoreDataProperties.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/06/22.
//
//

import CoreData
import Foundation

public extension Document {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Document> {
        NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged var title: String?
    @NSManaged var url: URL?
    @NSManaged var bookmark: Data?
}

extension Document: Identifiable {}
