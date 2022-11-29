//
//  IntelligenSAPApp.swift
//  IntelligenSAP
//
//  Created by David Palafox on 09/10/22.
//

import SwiftUI

@main
struct IntelligenSAPApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
