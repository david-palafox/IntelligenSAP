//
//  DayDetailActivity.swift
//  IntelligenSAP
//
//  Created by David Palafox on 28/11/22.
//

import SwiftUI

struct DayDetailActivity: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var day: Day
    @ObservedObject var activity: Activity
    @State var showActivity = false
    
    var body: some View {
        VStack (alignment: .leading) {
            activityDetail
            HStack {
                activityStatus
                Spacer()
                activityHours
            }
        }
        .onTapGesture { showActivity.toggle() }
        .sheet(isPresented: $showActivity,
               onDismiss: { day.objectWillChange.send() },
               content: { ActivityDetail(activity: activity)})
    }
    
    var activityDetail: some View {
        ZStack {
            if activity.wrappedDetail.isEmpty {
                Text("Nueva actividad").foregroundColor(.red)
            }
            Text(activity.wrappedDetail)
        }.padding(.bottom, 1)
    }
    
    var activityStatus: some View {
        HStack {
            Image(systemName: "checklist").font(.caption)
            Text("\(activity.wrappedStatus == "" ? "Sin estatus" : activity.wrappedStatus)")
                .font(.caption)
                .foregroundColor(activity.wrappedStatus == ActivityStatus.vacio.rawValue ? .red : .black)
        }.frame(alignment: .leading)
    }
    
    var activityHours: some View {
        HStack {
            Image(systemName: "timer").font(.caption)
            Text("\(activity.hours) hrs.")
                .font(.caption)
                .foregroundColor(activity.hours == 0 ? .red : .black)
        }.frame(alignment: .trailing)
    }
    
    func saveData() {
        if moc.hasChanges {
            try? moc.save()
        }
    }
}
