//
//  TimelineView.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/08.
//

import SwiftUI

struct TimelineView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)])
    var activities: FetchedResults<Activity>
    
    @State var isShowCalendar: Bool = false
    @State var selectedDate: Date = Date()
    
    func dateDisplay(date: Date) -> String {
        let dateSuffix = date.startOfDay == Date().startOfDay ? "（今日）" : ""
        let f = DateFormatter()
        f.timeZone = .current
        f.locale = Locale(identifier: "ja-JP")
        f.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        f.dateFormat = "yyyy年MM月dd日\(dateSuffix)"
        
        return f.string(from: date)
    }
    
    var startActivityView: some View {
        VStack(alignment: .center, spacing: 24) {
            Spacer()
            Text("今日もぼちぼち頑張ろう")
                .font(.title3)
                .bold()
            Text("まずは下のカテゴリから選んで始めよう")
                .font(.caption)
            Spacer()
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.beige
                    .ignoresSafeArea()
                VStack {
                    StorageView(data: activities.compactMap {$0}.sorted {$0.category?.name ?? "" < $1.category?.name ?? ""})
                        .padding(.horizontal)
                    if activities.isEmpty {
                        startActivityView
                    } else {
                        List(activities) {
                            activity in
                            ActivityView(activity: activity)
                                .foregroundColor(Color.navy)
                                .listRowSeparatorTint(Color.navy)
                                .listRowBackground(Color.beige)
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                    }
                    Spacer()
                    SelectCategoryListView() // FIXME: プレビュークラッシュするおそらくFetchRequestを使ってるからだと思われる
                }
                .onChange(of: selectedDate) {
                    newDate in
                    activities.nsPredicate = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", newDate.startOfDay as CVarArg, newDate.endOfDay as CVarArg)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "calendar")
                        .onTapGesture {
                            isShowCalendar.toggle()
                        }
                        .sheet(isPresented: $isShowCalendar) {
                            CalendarView(selectedDate: $selectedDate)
                            .presentationDetents([.medium])
                        }
                }
                ToolbarItem(placement: .principal) {
                    Text(dateDisplay(date: selectedDate))
                        .bold()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .scaledToFit()
                            .padding(8)
                            .background(Color.brownie)
                            .foregroundColor(Color.beige)
                            .mask(Circle())
                    }
                }
            }
            
        }
    }
}

struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
