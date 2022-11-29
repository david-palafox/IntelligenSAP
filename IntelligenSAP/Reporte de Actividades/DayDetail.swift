//
//  DayDetail.swift
//  IntelligenSAP
//
//  Created by David Palafox on 27/10/22.
//

import SwiftUI

struct DayDetail: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var day: Day
    
    var body: some View {
        NavigationStack {
            Form{
                workDayToggle
                
                if day.isWorkDay {
                    List {
                        ForEach(day.activitiesArray, id: \.self) { activity in
                            DayDetailActivity(day: day, activity: activity)
                        }.onDelete(perform: delete)
                    }
                    dayTotalHours
                }
            }
            .navigationTitle(titleDate(Int(day.date)))
            .if(day.isWorkDay) { view in
                view.navigationBarItems(trailing: addActivityButton)
            }
        }
    }
    
    var workDayToggle: some View {
        Section {
            HStack {
                Image(systemName: "rectangle.inset.filled.and.person.filled")
                Toggle("Día hábil", isOn: $day.isWorkDay)
                    .alert("Se eliminarán las actividades existentes",
                           isPresented: Binding<Bool>(get: { return !self.day.isWorkDay && !day.activitiesArray.isEmpty },
                                                      set: { p in self.day.isWorkDay = !p && !day.activitiesArray.isEmpty })) {
                        Button("Cancelar", role: .cancel) { }
                        Button("Aceptar") { removeDayActivities() }
                    }
            }
        }
    }
    
    var dayTotalHours: some View {
        Section {
            HStack {
                Image(systemName: "clock.badge.checkmark")
                Text("Total de horas trabajadas:")
                Spacer()
                Text(String(day.getWorkedHours()))
                    .foregroundColor(getHoursColor())
            }
        }
    }
    
    var addActivityButton: some View {
        Button("\(Image(systemName: "plus")) Actividad") {
            let activity = Activity(context: moc)
            activity.detail = ""
            activity.comment = ""
            activity.status = ActivityStatus.vacio.rawValue
            activity.createdAt = Date.now
            
            day.addToActivities(activity)
            day.objectWillChange.send()
        }
    }
    
    func titleDate(_ date: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es")
        dateFormatter.dateFormat = "LLLL \(date)"

        return dateFormatter.string(from: day.inMonth!.inTimeSheet!.date!).capitalized
    }
    
    func removeDayActivities() {
        if !day.activitiesArray.isEmpty {
            for activity in day.activitiesArray {
                day.removeFromActivities(activity)
                moc.delete(activity)
            }
        }
    }
    
    func delete(indexSet: IndexSet) {
        for index in indexSet {
            let activity = day.activitiesArray[index]
            day.removeFromActivities(activity)
            moc.delete(activity)
            try? moc.save()
        }
    }
    
    func getHoursColor() -> Color {
        if day.getWorkedHours() < day.getTotalHours() {
            return .black
        } else if day.getWorkedHours() == day.getTotalHours() {
            return .green
        } else {
            return .red
        }
    }
}
