//
//  CalendarView.swift
//  CalendarApp
//
//  Created by David Palafox on 11/10/22.
//

import SwiftUI
import MessageUI
import UniformTypeIdentifiers

struct CalendarView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest var timeSheets: FetchedResults<TimeSheet>
    @State var enviarCorreo: Bool = false
    @State var errorReporte: Bool = false
    
    var timeSheetDate: Date
    let constants = Constants.shared
    
    var body: some View {
        let timeSheet = getTimeSheet()
        var reportePath = ""
        VStack(spacing: 1) {
            Spacer()
            dayOfWeekStack
            calendarGrid(timeSheet)
            Spacer()
            Button(action: {
                if MFMailComposeViewController.canSendMail() {
                    reportePath = GeneradorDeReporte(timeSheet: timeSheet).generarReporte()
                    enviarCorreo.toggle()
                }
            }, label: {buttonLabel})
            .sendTimeSheetButton()
        }
        .padding(.horizontal)
        .sheet(isPresented: $enviarCorreo) {
            if let attachment = NSData(contentsOfFile: reportePath),
               let reporteURL = NSURL(string: reportePath) {
                let mimeType = getMimeType(reporteURL: reporteURL)
                let fileName = getFileName(reporteURL: reporteURL)
                
                MailView(to: constants.email,
                         subject: constants.subject,
                         content: constants.contentPreText,
                         attachment: attachment as Data,
                         mimeType: mimeType,
                         fileName: fileName)
            } else {
                Text("Oops!")
            }
        }
    }
    
    init(filter: Date) {
        let predicateFilter = filter
        _timeSheets = FetchRequest<TimeSheet>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "id == %@", CalendarHelper().getTimeSheetId(predicateFilter)))
        
        self.timeSheetDate = filter
    }
    
    var dayOfWeekStack: some View {
        HStack(spacing: 1) {
            Text("Dom").dayOfWeek()
            Text("Lun").dayOfWeek()
            Text("Mar").dayOfWeek()
            Text("Mié").dayOfWeek()
            Text("Jue").dayOfWeek()
            Text("Vie").dayOfWeek()
            Text("Sáb").dayOfWeek()
        }
        .background(Color("blue_accent"))
        .padding(.bottom, 5)
    }
    
    var buttonLabel: some View {
        HStack {
            Image(systemName: "list.bullet.clipboard")
            Text("Generar reporte")
        }
    }
    
    func getMimeType(reporteURL: NSURL) -> String {
        let fileExtension = reporteURL.pathExtension
        let mimeType = UTType(filenameExtension: fileExtension!)!.identifier
        return String(mimeType)
    }
    
    func getFileName(reporteURL: NSURL) -> String {
        return reporteURL.lastPathComponent!
    }
    
    private func calendarGrid(_ timeSheet: TimeSheet) -> some View {
        VStack(spacing: 1) {
            ForEach(0..<6) { row in
                HStack(spacing: 1) {
                    ForEach(1..<8) { column in
                        let count = column + (row * 7)
                        CalendarCell(day: timeSheet.month!.daysArray.first(where: { $0.number == count })!)
                    }
                }
            }
        }.frame(maxHeight: .infinity)
    }
    
    private func getTimeSheet() -> TimeSheet {
        var timeSheet: TimeSheet
        if timeSheets.isEmpty {
            timeSheet = TimeSheet(context: moc)
            timeSheet.date = CalendarHelper().getTimeSheetDate(timeSheetDate)
            timeSheet.id = CalendarHelper().getTimeSheetId(timeSheetDate)
            
            timeSheet.month = Month(context: moc)
            if let month = timeSheet.month {
                let components = Calendar.current.dateComponents([.year, .month], from: timeSheetDate)
                month.year = Int16(components.year!)
                month.month = Int16(components.month!)
                
                createMonthDays(month)
            }
            if moc.hasChanges {
                try? moc.save()
            }
        } else {
            timeSheet = timeSheets[0]
        }
        return timeSheet
    }
    
    private func createMonthDays(_ month: Month) {
        let daysInMonth = CalendarHelper().daysInMonth(timeSheetDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(timeSheetDate)
        let startingSpaces = CalendarHelper().weekDay(firstDayOfMonth)
        let prevMonth = CalendarHelper().minusMonth(timeSheetDate)
        let daysInPrevMonth = CalendarHelper().daysInMonth(prevMonth)
        
        for count in 1...42 {
            month.addToDays(createDay(count, startingSpaces, daysInMonth, daysInPrevMonth))
        }
    }
    
    private func createDay(_ count: Int, _ startingSpaces: Int, _ daysInMonth: Int, _ daysInPrevMonth: Int) -> Day {
        let monthStruct = monthStruct(count, startingSpaces, daysInMonth, daysInPrevMonth)
        let day = Day(context: moc)
        
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

private extension Text {
    func dayOfWeek() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding(.top, 1)
            .lineLimit(1)
            .foregroundColor(.white)
    }
}

private extension Button {
    func sendTimeSheetButton() -> some View {
        self
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(width: 240, alignment: .center)
            .padding(.vertical, 12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("blue_accent")))
            .background(Color("blue_accent").cornerRadius(12))
            .padding(.vertical, 50)
    }
}
