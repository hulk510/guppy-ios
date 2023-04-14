//
//  Persistence.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/07.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

//    inmemoryでもinmemoryじゃなくても初回の起動で保存するようにすればいけるのか？その場合アプリ消したときってちゃんとcoreDataのデータ消えるのか？
    // fetchして結果があればってふうにすればいいか。
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        var index = 1
        for category in DefaultCategories.allCases {
            let newCategory = Category(context: viewContext)
            newCategory.name = category.rawValue
            let activity = Activity(context: viewContext)
            activity.category = newCategory
            activity.note = ""
            activity.createdAt = Date()
            activity.updatedAt = Date()
            activity.startTime = Date()
            activity.endTime = Date(timeInterval: 60*60*Double(index), since: .now)
            index += 1
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Guppy")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
