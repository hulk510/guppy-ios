//
//  CategoryView.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/10.
//

import SwiftUI

struct CategoryView: View {
    @State private var isSelect: Bool = false
    let category: Category

    var body: some View {
        Button(action: {
            isSelect.toggle()
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .foregroundColor(Color.bluePaste)
                        .frame(width: 40, height: 40)
                    Image(category.key ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                Text(category.name ?? "")
                    .font(.caption2.bold())
                    .lineLimit(1)
            }
        }
        .onTapGesture {
            isSelect.toggle()
        }
        .frame(width: 64)
        .foregroundColor(Color.beige)
        .sheet(isPresented: $isSelect) {
            ActivityFormView(category: category)
                .presentationDetents([.medium])
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static let context = PersistenceController.preview.container.viewContext
    static let category = try! Category.findCategory(context: context, name: DefaultCategories.work.rawValue)!
    static var previews: some View {
        ZStack {
            Color.brownRed
                .ignoresSafeArea()
            CategoryView(category: category)
        }
    }
}
