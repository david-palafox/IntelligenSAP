//
//  CalendarAppApp.swift
//  CalendarApp
//
//  Created by David Palafox on 11/10/22.
//

import SwiftUI

@main
struct CalendarAppApp: App {
    var body: some Scene {
        WindowGroup {
            let dateHolder = DateHolder()
            CalendarView()
                .environmentObject(dateHolder)
        }
    }
}
