//
//  Activity+CoreDataClass.swift
//  Guppy
//
//  Created by 後藤遥 on 2023/02/17.
//

import Foundation
import CoreData

@objc(Activity)
public class Activity: NSManagedObject {
    static func fetchPrevActivity(context: NSManagedObjectContext, since: Date) throws -> Activity? {
        let a = Activity.fetchRequest()
        a.sortDescriptors = [NSSortDescriptor(keyPath: \Activity.startTime, ascending: false)]
        a.fetchLimit = 1
        a.predicate = NSPredicate(format: "startTime < %@ AND createdAt >= %@ AND createdAt =< %@", since as CVarArg, since.startOfDay as CVarArg, since.endOfDay as CVarArg)
        let activity = try context.fetch(a)
        return activity.first
    }

    static func fetchNextActivity(context: NSManagedObjectContext, since: Date) throws -> Activity? {
        let a = Activity.fetchRequest()
        a.sortDescriptors = [NSSortDescriptor(keyPath: \Activity.startTime, ascending: true)]
        a.fetchLimit = 1
        a.predicate = NSPredicate(format: "startTime > %@ AND createdAt >= %@ AND createdAt =< %@", since as CVarArg, since.startOfDay as CVarArg, since.endOfDay as CVarArg)
        let activity = try context.fetch(a)
        return activity.first
    }

    static func create(context: NSManagedObjectContext, category: Category, startTime: Date) throws {
        let prev = try fetchPrevActivity(context: context, since: startTime)
        let next = try fetchNextActivity(context: context, since: startTime)
        let now = Date()
        if let prev {
            prev.endTime = startTime
            prev.updatedAt = now
        }

        let a = Activity(context: context)
        a.category = category
        a.endTime = next?.startTime ?? nil
        a.startTime = startTime
        a.createdAt = now
        a.updatedAt = now
        a.note = ""
        try context.save()
    }

    static func update(context: NSManagedObjectContext, activity: Activity, startTime: Date, note: String) throws {
        let prev = try fetchPrevActivity(context: context, since: startTime)
        let next = try fetchNextActivity(context: context, since: startTime)
        let now = Date()
        if let prev {
            prev.endTime = startTime
            prev.updatedAt = now
        }
        let a = activity
        a.note = note
        a.endTime = next?.startTime ?? nil
        a.startTime = startTime
        a.updatedAt = now
        try context.save()
    }

    // stringUpdatedAtを呼び出すとString型のupdatedAtが返却される
    public var display: String { Self.dateFomatter(date: startTime ?? Date()) }

    // 24時間表示で12:00などで表示する
    static func dateFomatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = Locale(identifier: "ja-JP")
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        formatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")

        return formatter.string(from: date)
    }

    private var interval: TimeInterval {
        endTime?.timeIntervalSince(startTime ?? Date()) ?? 0
    }

    private var intervalInMinutes: Int {
        Int(round(interval) / 60)
    }

    private var intervalInHoursAndMinutes: (hours: Int, minutes: Int) {
        (intervalInMinutes / 60, intervalInMinutes % 60)
    }

    var usedTime: Double {
        Double(round(interval) / 3600)
    }

    func elaspedMin() -> String {
        let (hours: h, minutes: m) = intervalInHoursAndMinutes
        if h > 0 {
            return "\(h)時間\(m)分使ったよ"
        }
        if m == 0 {
            return ""
        }
        return "\(m)分使ったよ"
    }
}
