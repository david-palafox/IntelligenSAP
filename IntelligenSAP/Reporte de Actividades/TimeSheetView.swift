//
//  TimeSheetView.swift
//  IntelligenSAP
//
//  Created by David Palafox on 29/11/22.
//

import SwiftUI

struct TimeSheetView: View {
    @State var timeSheetDate = CalendarHelper().getTimeSheetDate(Date())
    
    var body: some View {
        VStack(spacing: 1) {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            dateScroller
            CalendarView(filter: timeSheetDate)
        }
    }
    
    var dateScroller: some View {
        HStack {
            Spacer()
            getArrowButton(previousMonth, "arrow.left")
            Text(CalendarHelper().monthYearString(timeSheetDate))
                .font(.title)
                .bold()
                .animation(.none)
                .frame(maxWidth: .infinity)
            getArrowButton(nextMonth, "arrow.right")
            Spacer()
        }.padding()
    }
    
    func getArrowButton(_ action: @escaping () -> Void, _ imageName: String) -> some View {
        return Button(action: action) {
            Image(systemName: imageName)
                .imageScale(.large)
                .font(Font.title.weight(.bold))
        }
    }
    
    func previousMonth() {
        timeSheetDate = CalendarHelper().minusMonth(timeSheetDate)
    }

    func nextMonth() {
        timeSheetDate = CalendarHelper().plusMonth(timeSheetDate)
    }
}
