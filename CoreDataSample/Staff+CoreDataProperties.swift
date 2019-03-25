//
//  Staff+CoreDataProperties.swift
//  CoreDataSample
//
//  Created by LevyGG on 2019/3/25.
//  Copyright © 2019 T@d. All rights reserved.
//
//

import Foundation
import CoreData


extension Staff {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Staff> {
        return NSFetchRequest<Staff>(entityName: "Staff")
    }

    @NSManaged public var country: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var sex: String?
    @NSManaged public var manager: Manager?
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension Staff {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: House)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: House)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}
