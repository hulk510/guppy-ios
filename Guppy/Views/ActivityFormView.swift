//
//  ActivityFormView.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/10.
//

import SwiftUI

struct ActivityFormView: View {
    let category: Category
    @State private var selectionDate = Date()
    @Environment(\.dismiss) var dismiss: DismissAction
    @Environment(\.managedObjectContext) private var viewContext
    
    func removeSecondsFromDate(_ date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return calendar.date(from: components)!
    }
    
    var body: some View {
        ZStack {
            Color.beige.opacity(0.8)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text(category.name!)
                    .font(.headline)
                    .foregroundColor(Color.navy)
                DatePicker("時刻を選択", selection: $selectionDate, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                Spacer()
                Button(action: {
                    do {
                        try Activity.create(context: viewContext, category: category, startTime: removeSecondsFromDate(selectionDate))
                    } catch {
                        print(error.localizedDescription)
                    }
                    dismiss()
                }) {
                    Text("登録")
                        .frame(maxWidth: .infinity, maxHeight: 24)
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 8)
                Button(action: { dismiss() }) {
                    Text("キャンセル")
                        .frame(maxWidth: .infinity, maxHeight: 24)
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}

struct ActivityFormView_Previews: PreviewProvider {
    static let context = PersistenceController.preview.container.viewContext
    static let category = try! Category.findCategory(context: context, name: DefaultCategories.bath.rawValue)!
    static var previews: some View {
        ActivityFormView(category: category)
            .frame(height: 500)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
