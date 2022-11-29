//
//  Constants.swift
//  SendMailApp
//
//  Created by Ege Sucu on 25.04.2022.
//

import Foundation

struct Constants{
    
    var email = ""
    
    let noSupportText = "El envío de correos no está habilitado en este dispositivo."
    let contentPreText = "Reporte de actividades para el mes de octubre."
    let sendButtonText = "Enviar reporte"
    let subject = "Reporte de actividades"
    
    static let shared = Constants()
    
    init() {
        if let file = Bundle.main.path(forResource: "Email", ofType: "txt") {
            do {
                self.email = try String(contentsOfFile: file)
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
}
