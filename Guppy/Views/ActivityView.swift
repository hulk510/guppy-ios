//
//  ActivityView.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/08.
//

import SwiftUI

struct ActivityView: View {
    @ObservedObject var activity: Activity
    @State private var isShowEdit: Bool = false
    @Environment(\.dismiss) var dismiss: DismissAction
    @Environment(\.managedObjectContext) private var viewContext
    @State private var note: String = ""
    @State private var selectionDate = Date()

    var body: some View {
        Button(action: {
            isShowEdit.toggle()
        }) {
            HStack(spacing: 24) {
                Text(activity.display)
                    .font(.headline)
                    .frame(width: 48)
                Rectangle()
                    .frame(width: 3)
                VStack(alignment: .leading) {
                    Text(activity.category?.name ?? "")
                        .font(.system(.caption, design: .monospaced))
                        .bold()
                    if let note = activity.note, !note.isEmpty {
                        Text(note)
                            .font(.system(.caption2, design: .monospaced))
                            .opacity(0.5)
                    }
                }
                Text(activity.elaspedMin())
                    .font(.caption)
            }
            .foregroundColor(Color.navy)
        }
        .sheet(isPresented: $isShowEdit) {
            VStack {
                Form {
                    DatePicker("時刻を選択", selection: $selectionDate, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                    TextField("メモ：", text: $note)
                }
                HStack {
                    Button(action: {
                        // TODO: 削除じゃなくて削除フラグで削除して後で復活させれるようにしたい
                        viewContext.delete(activity)
                        isShowEdit.toggle()
                    }) {
                        Text("削除")
                            .frame(maxWidth: .infinity, maxHeight: 24)
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.reddy)
                    Button(action: {
                        do {
                            try Activity.update(context: viewContext, activity: activity, startTime: selectionDate, note: note)
                        } catch {
                            print(error.localizedDescription)
                        }
                        isShowEdit.toggle()
                    }) {
                        Text("変更")
                            .frame(maxWidth: .infinity, maxHeight: 24)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.bluePaste)

                }
                .padding(.horizontal)
            }
            .background {
                Color.beige.opacity(0.8)
                    .ignoresSafeArea()
            }
            .presentationDetents([.medium, .large])
            .onAppear {
                selectionDate = activity.startTime!
            }
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static let context = PersistenceController(inMemory: true).container.viewContext
    static var s: Activity {
        let nc = Category(context: context)
        nc.name = "仕事"
        let ns = Activity(context: context)
        ns.endTime = Date(timeInterval: 60*60*12, since: .now)
        ns.startTime = Date()
        ns.note = "メモメモ"
        ns.createdAt = Date()
        ns.updatedAt = Date()
        ns.category = nc
        return ns
    }

    static var previews: some View {
        ActivityView(activity: s)
            .frame(height: 32)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
