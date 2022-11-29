//
//  Month+CoreDataProperties.swift
//  IntelligenSAP
//
//  Created by David Palafox on 25/11/22.
//
//

import Foundation
import CoreData


extension Month {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Month> {
        return NSFetchRequest<Month>(entityName: "Month")
    }

    @NSManaged public var month: Int16
    @NSManaged public var year: Int16
    @NSManaged public var days: NSSet?
    @NSManaged public var inTimeSheet: TimeSheet?
    
    public var daysArray: [Day] {
        let set = days as? Set<Day> ?? []
        return set.sorted {
            $0.number < $1.number
        }
    }
}

// MARK: Generated accessors for days
extension Month {

    @objc(addDaysObject:)
    @NSManaged public func addToDays(_ value: Day)

    @objc(removeDaysObject:)
    @NSManaged public func removeFromDays(_ value: Day)

    @objc(addDays:)
    @NSManaged public func addToDays(_ values: NSSet)

    @objc(removeDays:)
    @NSManaged public func removeFromDays(_ values: NSSet)

}

extension Month : Identifiable {

}
