//
//  GeneradorDeReporte2.swift
//  IntelligenSAP
//
//  Created by David Palafox on 08/11/22.
//

import SwiftUI
import SwiftXLSX

class GeneradorDeReporte2 {
    
    public static func generarReporte() -> String {
     
    //    let imgIntelligenSAPKey = XImages.append(with: XImage(with: ImageClass(named: "IntelligenSAP_Rep")!)!)
    //    let imgBancatlanKey = XImages.append(with: XImage(with: ImageClass(named: "Bancatlan_Rep")!)!)
    //    let imgSize = CGSize(width: 342, height: 110)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es")
        
        let book = XWorkBook()
        var sheet: XSheet
        var cell: XCell
        
    //  **************************************************  //
    //  Hoja de Carátula                                    //
    //  **************************************************  //
        sheet = book.newSheet("Carátula")
        
    //  Carátula.
        cell = sheet.addCell(XCoords(row: 2, col: 2))
        cell.alignmentHorizontal = .center
        cell.font = XFont(.Calibri, 18, true)
        cell.value = .text("Carátula")
        
    //  Proyecto.
        cell = sheet.addCell(XCoords(row:4, col: 2))
        cell.alignmentHorizontal = .left
        cell.font = XFont(.Calibri, 14, false)
        cell.value = .text("Proyecto:")

        cell = sheet.addCell(XCoords(row: 4, col: 3))
        cell.alignmentHorizontal = .left
        cell.font = XFont(.Calibri, 14, true)
        cell.value = .text("Banco Atlántida (Honduras)")

    //  Nombre consultor.
        cell = sheet.addCell(XCoords(row:5, col: 2))
        cell.alignmentHorizontal = .left
        cell.font = XFont(.Calibri, 14, false)
        cell.value = .text("Nombre Consultor:")

        cell = sheet.addCell(XCoords(row: 5, col: 3))
        cell.alignmentHorizontal = .left
        cell.font = XFont(.Calibri, 14, true)
        cell.value = .text("David Palafox Luna")

    //  Perfil.
        cell = sheet.addCell(XCoords(row:6, col: 2))
        cell.alignmentHorizontal = .left
        cell.font = XFont(.Calibri, 14, false)
        cell.value = .text("Perfil:")

        cell = sheet.addCell(XCoords(row: 6, col: 3))
        cell.alignmentHorizontal = .left
        cell.font = XFont(.Calibri, 14, true)
        cell.value = .text("Consultor SAP CRM")

    //  Fecha inicial.
        dateFormatter.dateFormat = "01/MM/yyyy"
        cell = sheet.addCell(XCoords(row:7, col: 2))
        cell.alignmentHorizontal = .left
        cell.font = XFont(.Calibri, 14, false)
        cell.value = .text("Fecha Inicial:")

        cell = sheet.addCell(XCoords(row: 7, col: 3))
        cell.alignmentHorizontal = .left
        cell.font = XFont(.Calibri, 14, true)
        cell.value = .text(dateFormatter.string(from: Date()))
        
    //  Anchos y altos de filas y columnas.
        sheet.forRowSetHeight(1, 15)
        sheet.forRowSetHeight(2, 24)
        sheet.forRowSetHeight(3, 15)
        sheet.forRowSetHeight(4, 19)
        sheet.forRowSetHeight(5, 19)
        sheet.forRowSetHeight(6, 19)
        sheet.forRowSetHeight(7, 19)

        sheet.forColumnSetWidth(1, 65)
        sheet.forColumnSetWidth(2, 154)
        sheet.forColumnSetWidth(3, 186)
        
    //  Combinación de celdas.
        sheet.mergeRect(XRect(2, 2, 2, 1)) //Carátula
        
    //  **************************************************  //
    //  Hoja de Reporte Mensual                             //
    //  **************************************************  //
        dateFormatter.dateFormat = "LLLL"
        sheet = book.newSheet(dateFormatter.string(from: Date()).uppercased())
            
        for i in 0...4 {
            let weekRows = i * 17

    //      FIXME: Inclusión de imagen.
    //        Imagen de IntelligenSAP.
    //        cell = sheet.addCell(XCoords(row: weekRows + 2, col: 3))
    //        cell.border = true
    //        cell.value = .icon(XImageCell(key: imgIntelligenSAPKey, size: imgSize))
            
    //      TODO: Quitar, es temporal.
    //      Imagen de IntelligenSAP.
            cell = sheet.addCell(XCoords(row: weekRows + 2, col: 3))
            cell.alignmentHorizontal = .center
            cell.alignmentVertical = .center
            cell.border = true
            cell.font = XFont(.Calibri, 16, false)
            cell.value = .text("IntelligenSAP")
            
    //      Reporte de Actividades Semana X.
            cell = sheet.addCell(XCoords(row: weekRows + 2, col: 4))
            cell.alignmentHorizontal = .center
            cell.alignmentVertical = .center
            cell.border = true
            cell.font = XFont(.Calibri, 16, true)
            cell.value = .text("Reporte de Actividades Semana \(i + 1)")

    //      FIXME: Inclusión de imagen
    //        Imagen Bancatlan.
    //        cell = sheet.addCell(XCoords(row: weekRows + 2, col: 9))
    //        cell.border = true
    //        cell.value = .icon(XImageCell(key: imgBancatlanKey, size: imgSize))
            
    //      TODO: Quitar, es temporal.
    //      Imagen Bancatlan.
            cell = sheet.addCell(XCoords(row: weekRows + 2, col: 9))
            cell.alignmentHorizontal = .center
            cell.alignmentVertical = .center
            cell.border = true
            cell.font = XFont(.Calibri, 16, false)
            cell.value = .text("Bancatlan")
            
    //      Nombre del proyecto/servicio.
            cell = sheet.addCell(XCoords(row: weekRows + 4, col: 3))
            cell.alignmentHorizontal = .left
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("Nombre del Proyecto/Servicio:")
            
            cell = sheet.addCell(XCoords(row: weekRows + 4, col: 4))
            cell.alignmentHorizontal = .left
            cell.border = true
            cell.font = XFont(.Calibri, 10, false)
            cell.value = .text("Banco Atlántida (Honduras)")
            
    //      Número de Contrato:
            cell = sheet.addCell(XCoords(row: weekRows + 5, col: 3))
            cell.alignmentHorizontal = .left
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("Número de Contrato:")
            
            cell = sheet.addCell(XCoords(row: weekRows + 5, col: 4))
            cell.alignmentHorizontal = .left
            cell.border = true
            cell.font = XFont(.Calibri, 10, false)
            cell.value = .text("")
            
    //      Nombre del consultor.
            cell = sheet.addCell(XCoords(row: weekRows + 6, col: 3))
            cell.alignmentHorizontal = .left
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("Nombre del Consultor:")
            
            cell = sheet.addCell(XCoords(row: weekRows + 6, col: 4))
            cell.alignmentHorizontal = .left
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("David Ricardo Palafox Luna")
            
    //      Perfil del consultor.
            cell = sheet.addCell(XCoords(row: weekRows + 7, col: 3))
            cell.alignmentHorizontal = .left
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("Perfil del Consultor:")
            
            cell = sheet.addCell(XCoords(row: weekRows + 7, col: 4))
            cell.alignmentHorizontal = .left
            cell.border = true
            cell.font = XFont(.Calibri, 10, false)
            cell.value = .text("Consultor SAP BPM")
            
    //      Tipo.
            cell = sheet.addCell(XCoords(row: weekRows + 8, col: 3))
            cell.alignmentHorizontal = .left
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("Tipo:")
            
            cell = sheet.addCell(XCoords(row: weekRows + 8, col: 4))
            cell.alignmentHorizontal = .left
            cell.border = true
            cell.font = XFont(.Calibri, 10, false)
            cell.value = .text("Proyecto")
            
    //      Mes de Reporte.
            cell = sheet.addCell(XCoords(row: weekRows + 4, col: 8))
            cell.alignmentHorizontal = .center
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("Mes de Reporte")
            
            cell = sheet.addCell(XCoords(row: weekRows + 5, col: 8))
            cell.alignmentHorizontal = .center
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text(dateFormatter.string(from: Date()).capitalized)
            
    //      Periodo de Reporte.
            cell = sheet.addCell(XCoords(row: weekRows + 7, col: 8))
            cell.alignmentHorizontal = .center
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("Periodo de Reporte")
            
            cell = sheet.addCell(XCoords(row: weekRows + 8, col: 8))
            cell.alignmentHorizontal = .center
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("Del:")
            
            cell = sheet.addCell(XCoords(row: weekRows + 8, col: 9))
            cell.alignmentHorizontal = .center
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("TODO: fecha")
            
            cell = sheet.addCell(XCoords(row: weekRows + 8, col: 10))
            cell.alignmentHorizontal = .center
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("Al:")
            
            cell = sheet.addCell(XCoords(row: weekRows + 8, col: 11))
            cell.alignmentHorizontal = .center
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("TODO: fecha")
            
    //      Cabecera de tabla.
            cell = sheet.addCell(XCoords(row: weekRows + 10, col: 2))
            cell.alignmentHorizontal = .center
            cell.alignmentVertical = .center
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("No.")
            
            cell = sheet.addCell(XCoords(row: weekRows + 10, col: 3))
            cell.alignmentHorizontal = .center
            cell.alignmentVertical = .center
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("Descripción de la Actividad")
            
            cell = sheet.addCell(XCoords(row: weekRows + 10, col: 5))
            cell.alignmentHorizontal = .center
            cell.alignmentVertical = .center
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("Día / Periodo")
            
            cell = sheet.addCell(XCoords(row: weekRows + 10, col: 6))
            cell.alignmentHorizontal = .center
            cell.alignmentVertical = .center
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("Observaciones")
            
            cell = sheet.addCell(XCoords(row: weekRows + 10, col: 11))
            cell.alignmentHorizontal = .center
            cell.alignmentVertical = .center
            cell.border = true
            cell.font = XFont(.Calibri, 10, true)
            cell.value = .text("Estatus")
            
    //      Numeración y renglones de tabla.
            for i in 1...5 {
                
    //          Numeración.
                cell = sheet.addCell(XCoords(row: weekRows + 10 + i, col: 2))
                cell.alignmentHorizontal = .center
                cell.alignmentVertical = .center
                cell.border = true
                cell.font = XFont(.Calibri, 10, false)
                cell.value = .text("\(i)")
                
    //          Descripción de la actividad.
                cell = sheet.addCell(XCoords(row: weekRows + 10 + i, col: 3))
                cell.alignmentHorizontal = .left
                cell.alignmentVertical = .center
                cell.border = true
                cell.font = XFont(.Calibri, 10, false)
                
    //          Día/Periodo.
                cell = sheet.addCell(XCoords(row: weekRows + 10 + i, col: 5))
                cell.alignmentHorizontal = .left
                cell.alignmentVertical = .center
                cell.border = true
                cell.font = XFont(.Calibri, 10, false)
                
    //          Observaciones.
                cell = sheet.addCell(XCoords(row: weekRows + 10 + i, col: 6))
                cell.alignmentHorizontal = .left
                cell.alignmentVertical = .center
                cell.border = true
                cell.font = XFont(.Calibri, 10, false)
                
    //          Estatus.
                cell = sheet.addCell(XCoords(row: weekRows + 10 + i, col: 11))
                cell.alignmentHorizontal = .left
                cell.alignmentVertical = .center
                cell.border = true
                cell.font = XFont(.Calibri, 10, false)
            }
        }
        
    //  Anchos y altos de filas y columnas.
        sheet.forColumnSetWidth( 1,   9)
        sheet.forColumnSetWidth( 2,  22)
        sheet.forColumnSetWidth( 3, 214)
        sheet.forColumnSetWidth( 4, 214)
        sheet.forColumnSetWidth( 5, 154)
        sheet.forColumnSetWidth( 6,  58)
        sheet.forColumnSetWidth( 7,  58)
        sheet.forColumnSetWidth( 8,  46)
        sheet.forColumnSetWidth( 9,  76)
        sheet.forColumnSetWidth(10,  46)
        sheet.forColumnSetWidth(11,  76)
        
        for i in 0...4 {
            let weekRows = i * 17
            sheet.forRowSetHeight(weekRows +  1, 14)
            sheet.forRowSetHeight(weekRows +  2, 82)
            sheet.forRowSetHeight(weekRows +  3, 14)
            sheet.forRowSetHeight(weekRows +  4, 16)
            sheet.forRowSetHeight(weekRows +  5, 16)
            sheet.forRowSetHeight(weekRows +  6, 16)
            sheet.forRowSetHeight(weekRows +  7, 16)
            sheet.forRowSetHeight(weekRows +  8, 16)
            sheet.forRowSetHeight(weekRows +  9, 14)
            sheet.forRowSetHeight(weekRows + 10, 25)
            sheet.forRowSetHeight(weekRows + 11, 15)
            sheet.forRowSetHeight(weekRows + 12, 15)
            sheet.forRowSetHeight(weekRows + 13, 15)
            sheet.forRowSetHeight(weekRows + 14, 15)
            sheet.forRowSetHeight(weekRows + 15, 15)
            sheet.forRowSetHeight(weekRows + 16,  8)
            sheet.forRowSetHeight(weekRows + 17,  8)
        }
        
    //  Combinación de celdas.
        for i in 0...4 {
            let weekRows = i * 17
            sheet.mergeRect(XRect(weekRows + 2, 4, 5, 1)) //Reporte de Actividades Semana X
            sheet.mergeRect(XRect(weekRows + 2, 9, 3, 1)) //Imagen del cliente
            sheet.mergeRect(XRect(weekRows + 4, 8, 4, 1)) //Mes de Reporte
            sheet.mergeRect(XRect(weekRows + 5, 8, 4, 1)) //Nombre del mes
            sheet.mergeRect(XRect(weekRows + 7, 8, 4, 1)) //Periodo de Reporte
            
            for j in 1...6 {
                let tableRows = weekRows + 9
                sheet.mergeRect(XRect(tableRows + j, 3, 2, 1)) //Descripción de la actividad
                sheet.mergeRect(XRect(tableRows + j, 6, 5, 1)) //Observaciones
            }
        }
        
    //  Guardado de archivo generado
        let fileId = book.save("ReporteDeActividades.xlsx")
        print("<<<File XLSX generated!>>>")
        print("\(fileId)")
        return fileId
    }
}
