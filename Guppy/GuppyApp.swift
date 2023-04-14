//
//  GuppyApp.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/07.
//

import SwiftUI
import CoreData

private let persistenceController = PersistenceController.shared

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
#if DEBUG
        deleteAllData()
#endif
    }
    
    // クラッシュ時にデータの変更を保存できるようにしておく
    func saveContext() {
        let context = persistenceController.container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MEMO: テストする時にデータあると邪魔なのでアプリ消すと消えるようにする
    func deleteAllData() {
        let context = persistenceController.container.viewContext
        print(persistenceController.container.managedObjectModel.entities)
        persistenceController.container.managedObjectModel.entities
            .compactMap(\.name)
            .forEach {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: $0)
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                do {
                    try context.execute(batchDeleteRequest)
                } catch {
                    print(error.localizedDescription)
                }
            }
        context.reset()
    }
}

@main
struct GuppyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isFirstAppear") var isFirstAppear = true

    var body: some Scene {
        WindowGroup {
            LoadDataView(isFirstAppear: $isFirstAppear) {
                ContentView()
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
