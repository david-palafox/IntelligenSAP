//
//  GeneradorDeReporte.swift
//  IntelligenSAP
//
//  Created by David Palafox on 09/10/22.
//

import SwiftUI
import SwiftXLSX

class GeneradorDeReporte {
    var timeSheet: TimeSheet
    
    init(timeSheet: TimeSheet) {
        self.timeSheet = timeSheet
    }
    
    public func generarReporte() -> String {
        let timeSheetDate = timeSheet.wrappedDate
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es")
        
        let book = XWorkBook()
        var sheet: XSheet
        
        //HOJA DE CARÁTULA.
        sheet = book.newSheet("CARÁTULA")
        
        buildCoverTitle(sheet)
        
        dateFormatter.dateFormat = "01/MM/yyyy"
        buildCoverLine(sheet, CoverRows.proyecto,  "Proyecto:",             "Banco Atlántida (Honduras)"             )
        buildCoverLine(sheet, CoverRows.consultor, "Nombre del consultor:", "David Palafox Luna"                     )
        buildCoverLine(sheet, CoverRows.perfil,    "Perfil:",               "Consultor SAP CRM"                      )
        buildCoverLine(sheet, CoverRows.fecha,     "Fecha inicial:",        dateFormatter.string(from: timeSheetDate))
        
        //Anchos y altos de filas y columnas.
        setCoverWidthsAndHeights(sheet)
        
        //HOJA DE REPORTE MENSUAL.
        dateFormatter.dateFormat = "LLLL"
        sheet = book.newSheet(dateFormatter.string(from: timeSheetDate).uppercased())
        
        let monthString = dateFormatter.string(from: timeSheetDate).capitalized
        var row = 1
        
        //Anchos y altos de filas y columnas.
        setTimeSheetWidthsAndHeights(sheet)
        
        //Definir semanas.
        var week = [Day]()
        var weeks = [[Day]]()
        
        for(index, day) in timeSheet.month!.daysArray.enumerated() {
            if index % 7 == 0 {
                week.removeAll()
            }
            if day.monthType == MonthType.Current.rawValue && day.isWorkDay {
                week.append(day)
            }
            if index % 7 == 6 && !week.isEmpty {
                weeks.append(week)
            }
        }
        
        //Crear reporte de actividades.
        for (index, week) in weeks.enumerated() {
            
            //Encabezado
            buildEmptyLine(sheet, row)
            
            row += 1
            buildTitleLine(sheet, row, TimeSheetColumns.month,    monthString                                    )
            buildTitleLine(sheet, row, TimeSheetColumns.week,     "Reporte semana \(index + 1)"                  )
            buildTitleLine(sheet, row, TimeSheetColumns.from,     "De:"                                          )
            buildTitleLine(sheet, row, TimeSheetColumns.fromDate, "\(timeSheet.month!.month)/\(week.first!.date)")
            buildTitleLine(sheet, row, TimeSheetColumns.to,       "A:"                                           )
            buildTitleLine(sheet, row, TimeSheetColumns.toDate,   "\(timeSheet.month!.month)/\(week.last!.date)" )
            buildTitleLine(sheet, row, TimeSheetColumns.client,   "Banco Atlántida (Honduras)  "                 )
            
            sheet.mergeRect(XRect(row, TimeSheetColumns.month,  2, 1))
            sheet.mergeRect(XRect(row, TimeSheetColumns.client, 3, 1))
            sheet.forRowSetHeight(row, 30)
            
            row += 1
            buildHeader(sheet, row, TimeSheetColumns.date,     "Fecha"    )
            buildHeader(sheet, row, TimeSheetColumns.dayHours, "Horas día")
            buildHeader(sheet, row, TimeSheetColumns.detail,   "Actividad")
            buildHeader(sheet, row, TimeSheetColumns.comment,  "Detalle"  )
            buildHeader(sheet, row, TimeSheetColumns.actHours, "Horas"    )
            buildHeader(sheet, row, TimeSheetColumns.status,   "Status"   )
            
            sheet.mergeRect(XRect(row, TimeSheetColumns.detail, 5, 1))
            sheet.forRowSetHeight(row, 25)
            row += 1
            
            var weekHours = 0
            for day in week {
                
                //Actividades
                if day.isWorkDay && !day.activitiesArray.isEmpty {
                    
                    addTimeSheetField(sheet, row, TimeSheetColumns.date,     "\(timeSheet.month!.month)/\(day.date)") //Fecha
                    addTimeSheetField(sheet, row, TimeSheetColumns.dayHours, "\(day.getWorkedHours())"              ) //Total hrs.
                    
                    if day.activitiesArray.count > 1 {
                        sheet.mergeRect(XRect(row, TimeSheetColumns.date,     1, day.activitiesArray.count))
                        sheet.mergeRect(XRect(row, TimeSheetColumns.dayHours, 1, day.activitiesArray.count))
                    }
                    
                    for activity in day.activitiesArray {
                        addTimeSheetField(sheet, row, TimeSheetColumns.detail,   activity.wrappedDetail  ) //Actividad
                        addTimeSheetField(sheet, row, TimeSheetColumns.comment,  activity.wrappedComment ) //Detalle
                        addTimeSheetField(sheet, row, TimeSheetColumns.actHours, String(activity.hours)  ) //Horas
                        addTimeSheetField(sheet, row, TimeSheetColumns.status,   activity.wrappedStatus  ) //Status
                        
                        sheet.mergeRect(XRect(row, TimeSheetColumns.detail, 5, 1))
                        row += 1
                    }
                }
                weekHours += day.getWorkedHours()
            }
            buildWeekHoursLine(sheet, row, weekHours)
            row += 1
        }
        
        //Guardado de archivo generado
        let fileId = book.save("ReporteDeActividades.xlsx")
        print("<<<File XLSX generated!>>>")
        print("\(fileId)")
        return fileId
    }
    
    private func buildCoverTitle(_ sheet: XSheet) {
        let cell = sheet.addCell(XCoords(row: CoverRows.title, col: CoverColumns.title))
        cell.alignmentHorizontal = .center
        cell.font = XFont(.Calibri, 18, true)
        cell.value = .text("Carátula")
    }
    
    private func buildCoverLine(_ sheet: XSheet, _ row: Int, _ label: String, _ value: String) {
        var cell: XCell
        
        cell = sheet.addCell(XCoords(row: row, col: CoverColumns.label))
        cell.alignmentHorizontal = .left
        cell.border = true
        cell.font = XFont(.Calibri, 14, false)
        cell.value = .text(label)
        
        cell = sheet.addCell(XCoords(row: row, col: CoverColumns.value))
        cell.alignmentHorizontal = .left
        cell.border = true
        cell.font = XFont(.Calibri, 14, true)
        cell.value = .text(value)
    }
    
    private func setCoverWidthsAndHeights(_ sheet: XSheet) {
        sheet.forRowSetHeight(1, 15)
        sheet.forRowSetHeight(2, 24)
        sheet.forRowSetHeight(3, 19)
        sheet.forRowSetHeight(4, 19)
        sheet.forRowSetHeight(5, 19)
        sheet.forRowSetHeight(6, 19)

        sheet.forColumnSetWidth(1, 65)
        sheet.forColumnSetWidth(2, 154)
        sheet.forColumnSetWidth(3, 186)
    }
    
    private func setTimeSheetWidthsAndHeights(_ sheet: XSheet) {
        sheet.forColumnSetWidth(  1,  23)
        sheet.forColumnSetWidth(  2,  59)
        sheet.forColumnSetWidth(  3,  59)
        sheet.forColumnSetWidth(  4, 245)
        sheet.forColumnSetWidth(  5,  47)
        sheet.forColumnSetWidth(  6,  83)
        sheet.forColumnSetWidth(  7,  47)
        sheet.forColumnSetWidth(  8,  83)
        sheet.forColumnSetWidth(  9, 485)
        sheet.forColumnSetWidth( 10,  41)
        sheet.forColumnSetWidth( 11,  71)
        sheet.forColumnSetWidth( 12,  23)
        sheet.forColumnSetWidth( 13,  59)
    }
    
    private func buildEmptyLine(_ sheet: XSheet, _ row: Int) {
        let cell = sheet.addCell(XCoords(row: row, col: 2))
        cell.value = .text("_")
        sheet.mergeRect(XRect(row, 2, 10, 1))
        sheet.forRowSetHeight(row, 30)
        cell.value = .text("")
    }
    
    private func buildTitleLine(_ sheet: XSheet, _ row: Int, _ col: Int, _ text: String) {
        let cell = sheet.addCell(XCoords(row: row, col: col))
        cell.alignmentHorizontal = {
            switch col {
            case TimeSheetColumns.week:
                return .left
            case TimeSheetColumns.client:
                return .right
            default:
                return .center
            }
        }()
        cell.alignmentVertical = .center
        cell.border = true
        cell.font = XFont(.Calibri, 18, false)
        cell.value = .text(text)
    }
    
    private func buildHeader(_ sheet: XSheet, _ row: Int, _ col: Int, _ text: String) {
        let cell = sheet.addCell(XCoords(row: row, col: col))
        cell.alignmentHorizontal = .center
        cell.alignmentVertical = .center
        cell.border = true
        cell.font = XFont(.Calibri, 13, true)
        cell.value = .text(text)
    }
    
    private func addTimeSheetField(_ sheet: XSheet, _ row: Int, _ col: Int, _ text: String) {
        let cell = sheet.addCell(XCoords(row: row, col: col))
        cell.alignmentHorizontal = {
            switch col {
            case TimeSheetColumns.detail, TimeSheetColumns.comment:
                return .left
            default:
                return .center
            }
        }()
        cell.alignmentVertical = {
            switch col {
            case TimeSheetColumns.date, TimeSheetColumns.dayHours:
                return .top
            default:
                return .center
            }
        }()
        cell.border = true
        cell.font = XFont(.Calibri, 11, false)
        cell.value = .text(text)
    }
    
    private func buildWeekHoursLine(_ sheet: XSheet, _ row: Int, _ weekHours: Int) {
        var cell: XCell
        
        cell = sheet.addCell(XCoords(row: row, col: TimeSheetColumns.weekHours))
        cell.alignmentHorizontal = .center
        cell.alignmentVertical = .center
        cell.border = true
        cell.font = XFont(.Calibri, 13, true)
        cell.value = .text("Total:")
        
        cell = sheet.addCell(XCoords(row: row, col: TimeSheetColumns.weekTotal))
        cell.alignmentHorizontal = .center
        cell.alignmentVertical = .center
        cell.border = true
        cell.font = XFont(.Calibri, 13, true)
        cell.value = .text(String(weekHours))
        
        cell = sheet.addCell(XCoords(row: row, col: TimeSheetColumns.weekEmpty))
        cell.value = .text("_")
        sheet.mergeRect(XRect(row, TimeSheetColumns.weekEmpty, 8, 1))
        sheet.forRowSetHeight(row, 25)
        cell.value = .text("")
    }
    
    private class CoverRows {
        static let title: Int     = 2
    
        static let proyecto: Int  = 3
        static let consultor: Int = 4
        static let perfil: Int    = 5
        static let fecha: Int     = 6
    }
    
    private class CoverColumns {
        static let title: Int = 2
        
        static let label: Int = 2
        static let value: Int = 3
    }
    
    private class TimeSheetColumns {
        static let month: Int     = 2
        static let week: Int      = 4
        static let from: Int      = 5
        static let fromDate: Int  = 6
        static let to: Int        = 7
        static let toDate: Int    = 8
        static let client: Int    = 9
        
        static let date: Int      = 2
        static let dayHours: Int  = 3
        static let detail: Int    = 4
        static let comment: Int   = 9
        static let actHours: Int  = 10
        static let status: Int    = 11
        
        static let weekHours: Int = 2
        static let weekTotal: Int = 3
        static let weekEmpty: Int = 4
    }
}
