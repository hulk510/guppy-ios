//
//  TimelineView.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/08.
//

import SwiftUI
//var activitys: [Activitys] = [
//    .init(name: "仕事", startTime: Date(), endTime: Date()),
//    .init(name: "Study", startTime: Date(), endTime: Date()),
//    .init(name: "遊び", startTime: Date(), endTime: Date()),
//    .init(name: "読書", startTime: Date(), endTime: Date()),
//    .init(name: "食事", startTime: Date(), endTime: Date()),
//    .init(name: "SIMPLE PATTERN", startTime: Date(), endTime: Date()),
//    .init(name: "休み", startTime: Date(), endTime: Date()),
//    .init(name: "お風呂", startTime: Date(), endTime: Date()),
//    .init(name: "ご飯", startTime: Date(), endTime: Date()),
//    .init(name: "歯磨き", startTime: Date(), endTime: Date()),
//    .init(name: "読書", startTime: Date(), endTime: Date()),
//    .init(name: "仕事", startTime: Date(), endTime: Date()),
//    .init(name: "休み", startTime: Date(), endTime: Date()),
//    .init(name: "仕事", startTime: Date(), endTime: Date()),
//    .init(name: "友達と遊ぶ", startTime: Date(), endTime: Date()),
//    .init(name: "スマホぽちぽち", startTime: Date(), endTime: Date()),
//    .init(name: "ネットフリックス", startTime: Date(), endTime: Date()),
//    .init(name: "外出", startTime: Date(), endTime: Date()),
//    .init(name: "お風呂", startTime: Date(), endTime: Date()),
//]
struct TimelineView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "endTime", ascending: true)], animation: .default)
    var activitys: FetchedResults<Activity>

    var body: some View {
        NavigationStack {
            ZStack {
                Color.beige
                    .ignoresSafeArea()
                VStack {
                    StorageView()
                        .padding(.horizontal)
                    List(activitys) {
                        activity in
                        ActivityView(activity: activity)
                            .foregroundColor(Color.navy)
                            .listRowSeparatorTint(Color.navy)
                            .listRowBackground(Color.beige)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                    Spacer()
                    SelectCategoryListView() // FIXME: Previewクラッシュする
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
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
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
