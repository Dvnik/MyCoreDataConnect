//
//  UseEntityStudent.swift
//  JunkTest
//
//  Created on 2022/12/13.
//

import Foundation

class UseEntityStudent: CDEntityBase {
    /**
     使用NSPersistentContainer的時候要用單例模式，
     如果每次呼叫都用新建的物件的話，
     NSPersistentContainer的預設狀態就會是空的，
     假設要做出像「刪除資料庫」這類的動作就會出現錯誤。
     */
    //MARK: Singleton
    public static var shared:UseEntityStudent {
        get {
            if entity == nil {
                entity = UseEntityStudent()
            }
            return entity
        }
    }
    private static var entity:UseEntityStudent!
    //MARK: values
    override var name: String {
        get { return "Student" }
    }
    override var model: String {
        get { return "SchoolData" }
    }
    //MARK: functions
    func addNewStudent(name: String, height: String) -> Bool {
        let allStudent = getAllStudent()
        var newData = [String: Any]()
        if let last = allStudent.last {
            newData["id"] = last.id + 1
        }
        else {
            newData["id"] = 1
        }
        
        newData["name"] = name
        newData["height"] = height
        
        return coreInsert(newData)
    }
    
    func getAllStudent() -> [Student] {
        return coreSearch(predicate: nil, sort: [["id":true]], limit: nil)
    }
    
    func findStudent(id: Int) -> Student? {
        let predicate = "id = \(id)"
        return coreSearch(predicate: predicate, sort: [["id":true]], limit: nil).first
    }
    
    func findStudent(name: String) -> [Student] {
        let predicate = "name = '\(name)'"
        return coreSearch(predicate: predicate, sort: [["id":true]], limit: nil)
    }
    
    func updateStudent(_ item: Student) -> Bool {
        // search predicate
        let predicate = "id = \(item.id)"
        //修改資料
        var values = [String:Any]()
        
        if let name = item.name {
            values["name"] = name
        }
        
        if let height = item.height {
            values["height"] = height
        }
        
        return coreUpdate(predicate: predicate, content: values)
    }
    
    func deleteStudent(_ item: Student) -> Bool {
        // search predicate
        let predicate = "id = \(item.id)"
        
        return coreDelete(predicate)
    }
    
    func deleteStudent(id: Int) -> Bool {
        if let student = findStudent(id: id) {
            return deleteStudent(student)
        }
        
        return false
    }
}
