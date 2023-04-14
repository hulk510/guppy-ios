//
//  CalendarViewRepresentable.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/03/02.
//

import SwiftUI
import FSCalendar

struct CalendarViewRepresentable: UIViewRepresentable {
    @Binding var currentMonth: Date
    @Binding var selectedDate: Date
    @Binding var events: [Event]
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator

        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        calendar.locale = Locale(identifier: "ja")
        calendar.appearance.headerMinimumDissolvedAlpha = 0 // 翌月表示するか0は非表示
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 16) //曜日テキストサイズ
        calendar.appearance.weekdayTextColor = UIColor(Color.brownRed) //曜日カラー
        calendar.appearance.titleWeekendColor = UIColor(Color.brownRed) //週末カラー

        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16) //日付テキストサイズ
        calendar.appearance.todayColor = UIColor(Color.bluePaste)
        calendar.appearance.selectionColor = UIColor(Color.brownie) //選択した日付カラー
        calendar.appearance.titleSelectionColor = UIColor(Color.white) //選択した日付のテキストカラー
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold) //ヘッダーテキストサイズ
        calendar.appearance.headerTitleOffset = CGPoint(x: 0, y: -4)
        calendar.appearance.headerDateFormat = "yyyy年MM月" //ヘッダーフォーマット
        calendar.appearance.headerTitleColor = UIColor(Color.brownRed)
        calendar.appearance.eventDefaultColor = UIColor(Color.gold)
        calendar.appearance.eventSelectionColor = UIColor(Color.gold)

        calendar.select(selectedDate) // 初期化時に現在選択してる日付を選択する
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        
        var parent: CalendarViewRepresentable
        
        init(_ parent: CalendarViewRepresentable) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            calendar.select(date) // タップした時に前の月ならカレンダーを前の月にする
            parent.selectedDate = date
        }
        
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            let event = parent.events.first { Calendar.current.isDate($0.date, inSameDayAs:date) }
            if event != nil {
                return 1
            }
            return 0
        }
        
        func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            parent.currentMonth = calendar.currentPage
        }
    }
}

struct CalendarViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        CalendarViewRepresentable(currentMonth: .constant(Date()), selectedDate: .constant(Date().startOfMonth), events: .constant([.init(date: Date()), .init(date: Date()), .init(date: Date().startOfWeek)]))
            .padding(.horizontal)
            .frame(height: 400)
    }
}
