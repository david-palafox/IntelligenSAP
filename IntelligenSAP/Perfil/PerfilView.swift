//
//  PerfilView.swift
//  IntelligenSAP
//
//  Created by David Palafox on 25/11/22.
//

import SwiftUI

struct PerfilView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var timeSheets: FetchedResults<TimeSheet>
    
    var body: some View {
        VStack {
            Text("Pantalla Perfil")
                .font(.system(size: 30, weight: .bold, design: .rounded))
            
            List(timeSheets, id: \.self) { timeSheet in
                Section(timeSheet.wrappedId) {
                    if let month = timeSheet.month {
                        ForEach(month.daysArray, id: \.self) { day in
                            HStack {
                                Text("Día: \(day.date) in \(day.monthType)").font(.caption)
                                Spacer()
                                Text("\(!day.isWorkDay ? "no " : "")hábil").font(.caption)
                            }.frame(height: 4)
                        }
                    }
                }
            }.environment(\.defaultMinListRowHeight, 4)
            Button("Borrar entidades") {
                for timeSheet in timeSheets {
                    moc.delete(timeSheet)
                }
                try? moc.save()
            }.padding()
        }
    }
}

struct PerfilView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilView()
    }
}
