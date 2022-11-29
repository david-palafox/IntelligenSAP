//
//  TimeSheet+CoreDataProperties.swift
//  IntelligenSAP
//
//  Created by David Palafox on 25/11/22.
//
//

import Foundation
import CoreData


extension TimeSheet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeSheet> {
        return NSFetchRequest<TimeSheet>(entityName: "TimeSheet")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var month: Month?
    
    public var wrappedDate: Date { date ?? Date.distantPast }
    public var wrappedId: String { id ?? "000000" }
    
    public func isComplete() -> Bool {
        var isComplete = true
        for day in month!.daysArray {
            isComplete = !day.isComplete() ? false : isComplete
        }
        return isComplete
    }
}

extension TimeSheet : Identifiable {

}
