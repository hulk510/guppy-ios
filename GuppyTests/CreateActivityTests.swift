//
//  CreateActivityTests.swift
//  GuppyTests
//
//  Created by 後藤遥 on 2023/02/17.
//

import XCTest
import CoreData
@testable import Guppy

struct TestActivity {
    let categoryName: String
    let startTime: Date
}

final class CreateActivityTests: XCTestCase {
    
    // テスト用のコンテキストを作成する
    var context: NSManagedObjectContext!
    
    // テストの前に呼ばれる
    override func setUp() {
        super.setUp()
        // テスト用のコンテキストを作成する
        let result = PersistenceController(inMemory: true)
        context = result.container.viewContext
        // デフォルトのカテゴリデータ作成
        for c in DefaultCategories.allCases {
            let category = Category(context: context)
            category.name = c.rawValue
            category.key = "\(c)"
            try! context.save()
        }
    }
    
    // テストの後に呼ばれる
    override func tearDown() {
        super.tearDown()
        // テスト用のコンテキストとモデルを破棄する
        context = nil
    }
    
    func test当日のデータのみ取得できるか() {
        // TODO: 当日のデータと昨日、未来のデータを取得してデータの件数が合ってるかどうか
    }
    
    // 活動開始のテスト
    func testCreateActivity() {
        // データを追加する
        let now = Date()
        let workCategory = try! Category.findCategory(context: context, name: "仕事")!
        try! Activity.create(context: context, category: workCategory, startTime: now)
        
        let request = Activity.fetchRequest()
        // コンテキストにデータが追加されたことを検証する
        let result = try! context.fetch(request)
        
        // result[0]とobjectを比較できるようにしたいな。
        XCTAssertEqual(result[0].note, "")
        XCTAssertEqual(result[0].startTime, now) // MEMO: 成功するけどテストの仕方違う気もする
        XCTAssertEqual(result[0].endTime, nil)
        XCTAssertEqual(result[0].category?.name, DefaultCategories.work.rawValue)
        XCTAssertEqual(result[0].note, "")
        XCTAssertEqual(result[0].createdAt, now)
        XCTAssertEqual(result[0].updatedAt, now)
        XCTAssertEqual(result.count, 1)
    }
    
    func testTwoActivity() {
        let now = Date()
        let threeHoursAgo = Calendar.current.date(byAdding: .hour, value: -3, to: now)!
        let workCategory = try! Category.findCategory(context: context, name: "仕事")
        
        try! Activity.create(context: context, category: workCategory!, startTime: threeHoursAgo)
        let request = Activity.fetchRequest()
        // コンテキストにデータが追加されたことを検証する
        let r1 = try! context.fetch(request)
        
        // startTimeが最後のActivityの時間になっているか
        XCTAssertEqual(r1[0].note, "")
        XCTAssertEqual(r1[0].startTime, threeHoursAgo)
        XCTAssertEqual(r1[0].endTime, nil)
        XCTAssertEqual(r1[0].category?.name, "仕事")
        XCTAssertNotNil(r1[0].createdAt!)
        XCTAssertNotNil(r1[0].updatedAt!)
        XCTAssertEqual(r1.count, 1)
        
        // 次のActivity開始
        let afterFiveHours = Calendar.current.date(byAdding: .hour, value: 5, to: now)!
        let bathCategory = try! Category.findCategory(context: context, name: "お風呂")
        try! Activity.create(context: context, category: bathCategory!, startTime: afterFiveHours)
        
        let r2 = try! context.fetch(request)
        XCTAssertEqual(r2[1].note, "")
        XCTAssertEqual(r2[1].startTime, afterFiveHours)
        XCTAssertEqual(r2[1].endTime, nil)
        XCTAssertEqual(r2[1].category?.name, "お風呂")
        XCTAssertNotNil(r2[1].createdAt!)
        XCTAssertNotNil(r2[1].updatedAt!)
        XCTAssertEqual(r2.count, 2)
        
        // 前のデータのendTimeがstartTimeに変わってるかどうか
        XCTAssertEqual(r2[0].endTime, afterFiveHours)
        XCTAssertEqual(r2[0].category?.name, "仕事")
//        XCTAssertEqual(r2[0].updatedAt!, r1[0].updatedAt!)
        XCTAssertEqual(r2.count, 2)
    }
    
    func testThreeActivity() {
        let now = Date()
        let threeHoursAgo = Calendar.current.date(byAdding: .hour, value: -3, to: now)!
        let afterFiveHours = Calendar.current.date(byAdding: .hour, value: 5, to: now)!

        let a1 = TestActivity(categoryName: "お風呂", startTime: threeHoursAgo)
        let a2 = TestActivity(categoryName: "仕事", startTime: afterFiveHours)
        let a3 = TestActivity(categoryName: "勉強", startTime: now) // 後ろにもデータがあればそのstartTimeをendTimeに入れる
        let testCase: [TestActivity] = [a1, a2, a3]
        
        for t in testCase {
            let category = try! Category.findCategory(context: context, name: t.categoryName)
            try! Activity.create(context: context, category: category!, startTime: t.startTime)
        }
        
        let request = Activity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Activity.startTime, ascending: true)]
        // コンテキストにデータが追加されたことを検証する
        let result = try! context.fetch(request)
        
        // startTimeが最後のActivityの時間になっているか
        XCTAssertEqual(result[0].startTime, threeHoursAgo)
        XCTAssertEqual(result[1].startTime, now)
        XCTAssertEqual(result[2].startTime, afterFiveHours)
        
        XCTAssertEqual(result[0].endTime, now)
        XCTAssertEqual(result[1].endTime, afterFiveHours)
        XCTAssertEqual(result[2].endTime, nil)
        
        XCTAssertEqual(result[0].category?.name, "お風呂")
        XCTAssertEqual(result[1].category?.name, "勉強")
        XCTAssertEqual(result[2].category?.name, "仕事")
        XCTAssertEqual(result.count, 3)
    }
    
    // データの削除をテストする
    func testDeleteData() {
        // データを追加する
        let new = Activity(context: context)
        new.note = "Hello"
        
        // コンテキストにデータが追加されたことを検証する
        let request = NSFetchRequest<Activity>(entityName: "Activity")
        var result = try! context.fetch(request)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].note, "Hello")
        
        // データを削除する
        context.delete(result[0])
        
        // コンテキストからデータが削除されたことを検証する
        result = try! context.fetch(request)
        XCTAssertEqual(result.count, 0)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
