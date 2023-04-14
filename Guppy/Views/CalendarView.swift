//
//  CalendarView.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/03/09.
//

import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    @State var currentMonth: Date = Date()
    @State var events: [Event] = []
    
    @FetchRequest
    var monthActivities: FetchedResults<Activity>
    var groupedActivityByCreatedAt: [Date : [FetchedResults<Activity>.Element]] {
        Dictionary(grouping: monthActivities, by: { $0.createdAt! })
    }
    
    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        
        let now = Date()
        self._monthActivities = FetchRequest(
            sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: true)],
            predicate: NSPredicate(
                format: "createdAt >= %@ AND createdAt <= %@", now.startOfMonth as CVarArg, now.endOfMonth as CVarArg
            )
        )
    }
    
    func createEvents(_ data: [Activity]) {
        for event in data {
            events.append(.init(date: event.createdAt!))
        }
    }
    
    var body: some View {
        VStack {
            CalendarViewRepresentable(currentMonth: $currentMonth, selectedDate: $selectedDate, events: $events)
                .padding(.horizontal)
                .frame(height: 320)
        }
        .onAppear {
            createEvents(monthActivities.sorted(by: {$0.createdAt! < $1.createdAt!}))
        }
        .onChange(of: monthActivities.sorted(by: {$0.createdAt! < $1.createdAt!})) {
            data in
            createEvents(data)
        }
        .onChange(of: currentMonth) {
            newDate in
            monthActivities.nsPredicate = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", newDate.startOfMonth as CVarArg, newDate.endOfMonth as CVarArg)
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(selectedDate: .constant(Date()))
    }
}
