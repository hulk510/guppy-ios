//
//  Activity+CoreDataProperties.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/17.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var note: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var startTime: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var category: Category?

}

extension Activity : Identifiable {

}
