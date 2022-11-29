//
//  Day+CoreDataProperties.swift
//  IntelligenSAP
//
//  Created by David Palafox on 25/11/22.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }
    
//    @NSManaged public var isComplete: Bool
    
    @NSManaged public var number: Int16
    @NSManaged public var date: Int16
    @NSManaged public var isWorkDay: Bool
    @NSManaged public var monthType: Int16
    @NSManaged public var activities: NSSet?
    @NSManaged public var inMonth: Month?
    
    public var activitiesArray: [Activity] {
        let set = activities as? Set<Activity> ?? []
        return Array(set).sorted{ $0.createdAt! > $1.createdAt! }
    }
    
    public func getWorkedHours() -> Int {
        var sum = 0
        for activity in activitiesArray {
            sum += Int(activity.hours)
        }
        return sum
    }
    
    public func isTimeMet() -> DayTimeMet {
        let workedHours = getWorkedHours()
        let totalHours = getTotalHours()
        
        switch workedHours {
        case _ where workedHours < totalHours:
            return .under
        case _ where workedHours > totalHours:
            return .over
        default:
            return .timeMet
        }
    }
    
    public func getTotalHours() -> Int {
        return 8
    }
    
    public func isComplete() -> Bool {
        var isComplete = true
        for activity in activitiesArray {
            isComplete = !activity.isComplete() ? false : isComplete
        }
        return isComplete
    }
}

// MARK: Generated accessors for activities
extension Day {

    @objc(addActivitiesObject:)
    @NSManaged public func addToActivities(_ value: Activity)

    @objc(removeActivitiesObject:)
    @NSManaged public func removeFromActivities(_ value: Activity)

    @objc(addActivities:)
    @NSManaged public func addToActivities(_ values: NSSet)

    @objc(removeActivities:)
    @NSManaged public func removeFromActivities(_ values: NSSet)

}

extension Day : Identifiable {

}

public enum DayTimeMet: Int {
    case under = -1
    case timeMet = 0
    case over = 1
}
