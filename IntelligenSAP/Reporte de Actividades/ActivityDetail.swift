//
//  ActivityDetail.swift
//  IntelligenSAP
//
//  Created by David Palafox on 20/10/22.
//

import SwiftUI
import Combine

struct ActivityDetail: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @ObservedObject var activity: Activity
    var activityStatus = ["", "Análisis", "Desarrollo", "Pruebas", "Ajustes", "Terminado"]
    
    var body: some View {
        NavigationStack {
            Form {
                detail
                comment
                status
                hours
            }
            .navigationTitle("Actividad")
            .navigationBarItems(trailing: deleteActivityButton)
        }
    }
    
    var detail: some View {
        ZStack(alignment: .topLeading) {
            getPlaceholderText(activity.wrappedDetail, "Detalle")
            TextEditor(text: $activity.detail.toUnwrapped(defaultValue: ""))
//                .onReceive(Just(activity.detail)) { _ in limitText(activity.detail, 100) }
                .frame(height: 75)
        }
    }
    
    var comment: some View {
        ZStack(alignment: .topLeading) {
            getPlaceholderText(activity.wrappedComment, "Comentario")
            TextEditor(text: $activity.comment.toUnwrapped(defaultValue: ""))
//                .onReceive(Just(activity.comment)) { _ in limitText(activity.comment, 100) }
                .frame(height: 75)
        }
    }
    
    var status: some View {
        HStack {
            Image(systemName: "checklist")
            Picker("Estatus", selection: $activity.status.toUnwrapped(defaultValue: ActivityStatus.vacio.rawValue)) {
                ForEach(activityStatus, id: \.self) { status in
                    Text(status)
                }
            }
        }
    }
    
    var hours: some View {
        HStack {
            Image(systemName: "timer")
            Stepper("Esfuerzo en horas: \(activity.hours)", value: $activity.hours, in: 0...8)
        }
    }
    
    var deleteActivityButton: some View {
        Button("\(Image(systemName: "trash")) Eliminar") {
            if let day = activity.inDay {
                day.removeFromActivities(activity)
            }
            moc.delete(activity)
            dismiss()
        }
    }
    
    func getPlaceholderText(_ value: String, _ title: String) -> some View {
        return Text( value.isEmpty ? title : "")
            .padding(.top, 8)
            .padding(.leading, 6)
            .foregroundColor(.gray)
    }
    
    func limitText(_ value: String, _ upper: Int) {
        if activity.wrappedDetail.count > upper {
            activity.detail = String(activity.wrappedDetail.prefix(upper))
        }
    }
}
