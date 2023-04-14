//
//  SelectCategoryListView.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/08.
//

import SwiftUI
import SFUserFriendlySymbols

struct SelectCategoryListView: View {
    
    @FetchRequest(sortDescriptors: [], animation: .spring())
    var categories: FetchedResults<Category>
    
    @ViewBuilder
    func hideStartEndCategoryView(category: Category) -> some View {
        let end = DefaultCategories.end.rawValue
        if category.name! != end {
            CategoryView(category: category)
        } else {
            EmptyView()
        }
    }

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(categories) {
                    category in
                    hideStartEndCategoryView(category: category)
                }
            }
        }
        .background {
            Image("slim_banner")
                .resizable()
                .opacity(0.8)
                .scaledToFill()
                .background(Color.brownRed)
        }
        .mask(Rectangle())
        .frame(height: 88)
    }
}

struct SelectCategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCategoryListView()
    }
}
