//
//  TimeSheetGenerator.swift
//  IntelligenSAP
//
//  Created by David Palafox on 28/11/22.
//

import Foundation
import SwiftUI

class TimeSheetGenerator {
    var forDate: Date
    var timeSheets: [TimeSheet]
    
    init(forDate: Date, from timeSheets: [TimeSheet]) {
        self.forDate = forDate
        self.timeSheets = timeSheets
    }
    
    public func getTimeSheet() -> TimeSheet {
        var timeSheet: TimeSheet
        if timeSheets.isEmpty {
            timeSheet = TimeSheet()//context: moc)
            timeSheet.date = CalendarHelper().getTimeSheetDate(forDate)
            timeSheet.id = CalendarHelper().getTimeSheetId(forDate)
            
            timeSheet.month = Month()//context: moc)
            if let month = timeSheet.month {
                let components = Calendar.current.dateComponents([.year, .month], from: forDate)
                month.year = Int16(components.year!)
                month.month = Int16(components.month!)
                
                createMonthDays(month)
            }
//            try? moc.save()
        } else {
            timeSheet = timeSheets[0]
        }
        return timeSheet
    }
    
    private func createMonthDays(_ month: Month) {
        let daysInMonth = CalendarHelper().daysInMonth(forDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(forDate)
        let startingSpaces = CalendarHelper().weekDay(firstDayOfMonth)
        let prevMonth = CalendarHelper().minusMonth(forDate)
        let daysInPrevMonth = CalendarHelper().daysInMonth(prevMonth)
        
        for count in 1...42 {
            month.addToDays(createDay(count, startingSpaces, daysInMonth, daysInPrevMonth))
        }
    }
    
    private func createDay(_ count: Int, _ startingSpaces: Int, _ daysInMonth: Int, _ daysInPrevMonth: Int) -> Day {
        let monthStruct = monthStruct(count, startingSpaces, daysInMonth, daysInPrevMonth)
        let day = Day()//context: moc)
        
        day.number = Int16(count)
        day.date = Int16(monthStruct.dayInt)
        day.monthType = Int16(monthStruct.monthType.rawValue)
        day.isWorkDay = (count % 7 == 0 || count % 7 == 1) ? false : true
        
        return day
    }
    
    private func monthStruct(_ count: Int, _ startingSpaces: Int, _ daysInMonth: Int, _ daysInPrevMonth: Int) -> MonthStruct {
        let start = startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
        if(count <= start) {
            let day = daysInPrevMonth + count - start
            return MonthStruct(monthType: MonthType.Previous, dayInt: day)
        }
        else if (count - start > daysInMonth) {
            let day = count - start - daysInMonth
            return MonthStruct(monthType: MonthType.Next, dayInt: day)
        }
        let day = count - start
        return MonthStruct(monthType: MonthType.Current, dayInt: day)
    }
}

enum MonthType: Int, Codable {
    case Previous = -1
    case Current = 0
    case Next = 1
}

struct MonthStruct {
    var monthType: MonthType
    var dayInt : Int
    func day() -> String {
        return String(dayInt)
    }
}

