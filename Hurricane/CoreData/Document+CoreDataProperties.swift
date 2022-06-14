//
//  Document+CoreDataProperties.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/06/22.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var bookmark: Data?

}

extension Document : Identifiable {

}
