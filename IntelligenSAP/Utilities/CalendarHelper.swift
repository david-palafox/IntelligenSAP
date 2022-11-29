//
//  CalendarHelper.swift
//  CalendarApp
//
//  Created by David Palafox on 11/10/22.
//

import Foundation

class CalendarHelper
{
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    func monthYearString(_ date: Date) -> String {
        dateFormatter.locale = Locale(identifier: "es")
        dateFormatter.dateFormat = "LLL. yyyy"
        return dateFormatter.string(from: date).capitalized
    }
    
    func getTimeSheetDate(_ date: Date) -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.month, .year], from: date))!
    }
    
    func getTimeSheetId(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        return dateFormatter.string(from: date)
    }
    
    func plusMonth(_ date: Date) -> Date {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func minusMonth(_ date: Date) -> Date {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func daysInMonth(_ date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func dayOfMonth(_ date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstOfMonth(_ date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(_ date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
}
