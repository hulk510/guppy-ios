//
//  LoadDataView.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/18.
//

import SwiftUI

struct LoadDataView<Content:View>: View {
    @Binding var isFirstAppear: Bool
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    var categories: FetchedResults<Category>
    
    let content: Content
    
    init(isFirstAppear: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isFirstAppear = isFirstAppear
        self.content = content()
    }
    
    func loadData() throws {
        for c in DefaultCategories.allCases {
            let category = Category(context: viewContext)
            category.name = c.rawValue
            category.key = "\(c)"
            try viewContext.save()
        }
    }
    
    var body: some View {
        content
            .onAppear {
#if DEBUG
                // MEMO:テスト時は常に初回起動として扱う
                isFirstAppear = true
#endif
                if !isFirstAppear {
                    return
                }
                if categories.count == 0 {
                    do {
                        try loadData()
                        isFirstAppear = false
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
            }
    }
}

struct LoadDataView_Previews: PreviewProvider {
    static var previews: some View {
        LoadDataView(isFirstAppear: .constant(true)) {
            Text("hello, world")
        }
    }
}
