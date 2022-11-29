//
//  CalendarCell.swift
//  CalendarApp
//
//  Created by David Palafox on 12/10/22.
//

import SwiftUI
import AVFoundation

struct CalendarCell: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var day: Day
    @State var showDetail: Bool = false
    
    let calendarCellPB = UIPasteboard.Name("calendarCellPB")
    
    var body: some View {
        if(Int(day.monthType) == MonthType.Current.rawValue) {
            Menu(content: { dayMenu },
                 label: { cellContent },
                 primaryAction: { showDetail.toggle() })
            .menuOrder(.fixed)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $showDetail,
                   onDismiss: { saveData() },
                   content: { DayDetail(day: day)})
        } else {
            cellContent
        }
    }
    
    var cellContent: some View {
        ZStack {
            if(Int(day.monthType) == MonthType.Current.rawValue) {
                let percentage = CGFloat(day.getWorkedHours())/CGFloat(day.getTotalHours())
                Circle()
                    .foregroundColor(circleColor(day: day))
                    .if(circleColor(day: day) == Color("blue_light")) { view in
                        view.overlay( GeometryReader { geometry in
                            let progressWidth: CGFloat = geometry.size.width / 8
                            Circle()
                                .trim(from: 0, to: percentage)
                                .stroke(Color("blue_lettering").opacity(1.0), style: StrokeStyle(lineWidth: progressWidth, lineCap: .round))
                                .frame(maxWidth: geometry.size.width - progressWidth, maxHeight: geometry.size.height - progressWidth)
                                .position(x: geometry.size.width / 2, y: geometry.size.width / 2)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut, value: percentage)
                        })
                    }
            }
            Text(String(day.date))
                .foregroundColor(textColor(type: Int(day.monthType)))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    var dayMenu: some View {
        return VStack {
            if !day.activitiesArray.isEmpty {
                Button(action: copyDayActivities,
                       label: { HStack {
                    Image(systemName: "doc.on.doc")
                    Text("Copiar actividades")
                }})
            }
            if let pasteboard = UIPasteboard(name: calendarCellPB, create: true) {
                if pasteboard.hasStrings {
                    Button(action: pasteDayActivities,
                           label: { HStack {
                        Image(systemName: "doc.badge.arrow.up")
                        Text("Pegar actividades")
                    }})
                }
            }
        }
    }
    
    func circleColor(day: Day) -> Color {
        if day.isWorkDay {
            if day.isTimeMet() == .over || !day.isComplete() {
                return .red
            } else if day.isTimeMet() == .timeMet && day.isComplete() {
                return Color("blue_lettering")
            } else {
                return Color("blue_light")
            }
        } else {
            return Color("beige")
        }
    }
    
    func textColor(type: Int) -> Color {
        return type == MonthType.Current.rawValue ? .black : .gray
    }
    
    func copyDayActivities() {
        if let pasteboard = UIPasteboard(name: calendarCellPB, create: true) {
            pasteboard.items.removeAll()
            
            var items = [[String: Any]]()
            for activity in day.activitiesArray {
                items.append([UTType.utf8PlainText.identifier: activity.wrappedDetail])
                items.append([UTType.utf8PlainText.identifier: activity.wrappedComment])
                items.append([UTType.utf8PlainText.identifier: activity.wrappedStatus])
                items.append([UTType.utf8PlainText.identifier: String(activity.hours)])
            }
            pasteboard.addItems(items)
        }
    }
    
    func pasteDayActivities() {
        if let pasteboard = UIPasteboard(name: calendarCellPB, create: true) {
            for activity in day.activitiesArray {
                moc.delete(activity)
            }
            day.isWorkDay = true
            
            var detail = ""
            var comment = ""
            var status = ""
            var hours = 0
            
            for (index, item) in pasteboard.items.enumerated() {
                switch index % 4 {
                case 0:
                    detail = item[UTType.utf8PlainText.identifier] as? String ?? ""
                case 1:
                    comment = item[UTType.utf8PlainText.identifier] as? String ?? ""
                case 2:
                    status = item[UTType.utf8PlainText.identifier] as? String ?? ""
                case 3:
                    hours = Int(item[UTType.utf8PlainText.identifier] as! String)!
                    
                    let activity = Activity(context: moc)
                    activity.detail = detail
                    activity.comment = comment
                    activity.status = status
                    activity.hours = Int16(hours)
                    day.addToActivities(activity)
                default:
                    print("Impossible to get here!!")
                }
            }
            day.objectWillChange.send()
        }
    }
    
    func saveData() {
        day.objectWillChange.send()
        if moc.hasChanges {
            try? moc.save()
        }
    }
}
