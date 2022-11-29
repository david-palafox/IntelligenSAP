//
//  Activity+CoreDataProperties.swift
//  IntelligenSAP
//
//  Created by David Palafox on 25/11/22.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var comment: String?
    @NSManaged public var detail: String?
    @NSManaged public var hours: Int16
    @NSManaged public var status: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var inDay: Day?
    
    public var wrappedComment: String { comment ?? "" }
    public var wrappedDetail: String { detail ?? "" }
    public var wrappedStatus: String { status ?? "" }
    
    public func isComplete() -> Bool {
        return !wrappedDetail.isEmpty && wrappedStatus != ActivityStatus.vacio.rawValue && hours > 0 ? true : false
    }
}

extension Activity : Identifiable {

}

enum ActivityStatus: String, CaseIterable, Identifiable {
    var id: ActivityStatus { self }
    
    case vacio = ""
    case analisis = "Análisis"
    case desarrollo = "Desarrollo"
    case pruebas = "Pruebas"
    case ajustes = "Ajustes"
    case terminado = "Terminado"
}


