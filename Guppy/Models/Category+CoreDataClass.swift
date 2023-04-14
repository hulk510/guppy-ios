//
//  Category+CoreDataClass.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/16.
//
//

import Foundation
import CoreData

// DBに画像の値も含め持たせた方が便利かな？
// TODO: EnumのキーとCategoryのキーで比較できるようにしたい
// 現状rawValueでテキストの方で検索してるのなんか微妙
enum DefaultCategories: String, CaseIterable {
    case start = "起床"
    case end = "活動終了"
    case work = "仕事"
    case school = "学校"
    case study = "勉強"
    case meal = "ごはん"
    case chill = "休憩"
    case out = "外出"
    case bath = "お風呂"
    case fitness = "運動"
}

@objc(Category)
public class Category: NSManagedObject {
    // TODO: せっかくkey持ってるならkeyで検索できるようにした方がいい
    static func findCategory(context: NSManagedObjectContext, name: String) throws -> Category? {
        let c = Category.fetchRequest()
        c.sortDescriptors = []
        c.predicate = NSPredicate(format: "name == %@", name)
        c.fetchLimit = 1
        
        let category = try context.fetch(c)
        return category.first
    }
}
