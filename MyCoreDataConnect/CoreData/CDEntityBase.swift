//
//  CDEntityBase.swift
//  JunkTest
//
//  Created on 2022/12/13.
//
// 直接調用CoreData資料庫的內容簡易方法，可獨立作業
// 以Student作為CoreData的範例，實現新增/修改/刪除/查詢資料的方法
import Foundation
//NSPersistentContainer/NSManagedObjectModel 會用到
import CoreData

class CDEntityBase: NSObject {
    //MARK: values
    // entity name即CoreData的資料表名稱，使用CoreData的時候會需要知道是要對哪個entity做事
    var name: String {
        get { return "EntityBase"}
    }
    // 取得 app bundle id
    // 做成Framework的話就不一定會和bundle id 一致
    var identifier: String {
        get { return Bundle.main.bundleIdentifier ?? "com.apple.com"}
    }
    //CoreData的名稱，是.xcdatamodeld的檔案名稱
    var model: String {
        get { return "CoreData"}
    }
    // 變成Framework以後，不是去AppDelegate取用persistentContainer，而是要自己做
    // 而這個自己做的過程也可以用在APP開發上
    private lazy var persistentContainer: NSPersistentContainer = {
        // Create managed object model
        let messageKitBundle = Bundle(identifier: identifier)!
        let modelURL = messageKitBundle.url(forResource: model, withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        // create NSPersistentContainer
        let container = NSPersistentContainer(name: model, managedObjectModel: managedObjectModel)
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("❌ Loading of store failed:\(error)")
            }
        }
        return container
    }()
    // 採用CoreDataConnect來操作CoreData
    private lazy var useCoreDataConnect: CoreDataConnect = {
        // 用來操作 Core Data 的常數
        let moc = self.persistentContainer.viewContext
        return CoreDataConnect(context: moc)
    }()
    // MARK: CRUD
    // create
    func coreInsert(_ content:[String:Any]) -> Bool {
        return useCoreDataConnect.insert(name, attributeInfo: content)
    }
    // read
    func coreSearch<T>(predicate:String?, sort:[[String:Bool]]?, limit:Int?) -> [T] {
        if let result = useCoreDataConnect.retrieve(name, predicate: predicate, sort: sort, limit: limit) as? [T] {
            return result
        }
        
        return [T]()
    }
    // update
    func coreUpdate(predicate: String?, content:[String:Any]) -> Bool {
        return useCoreDataConnect.update(name, predicate: predicate, attributeInfo: content)
    }
    // delete
    func coreDelete(_ predicate: String?) -> Bool {
        return useCoreDataConnect.delete(name, predicate: predicate)
    }
}
