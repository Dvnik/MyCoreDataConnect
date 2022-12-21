//
//  CoreDataConnect.swift
//  ExCoreData
//
//  Created by joe feng on 2018/11/5.
//  Copyright © 2018年 Feng. All rights reserved.
//

import Foundation
import CoreData

class CoreDataConnect {
    var myContext :NSManagedObjectContext! = nil
    
    init(context:NSManagedObjectContext) {
        self.myContext = context
    }
    
    //MARK:- insert
    func insert(_ myEntityName:String,
                attributeInfo:[String:Any]) -> Bool {
        
        let insetData = NSEntityDescription.insertNewObject(forEntityName: myEntityName,
                                                            into: myContext)
        
        for (key,value) in attributeInfo {
            insetData.setValue(value, forKey: key)
        }
        
        do {
            try myContext.save()
            return true
        } catch {
            fatalError("\(error)")
        }

    }
    
    //MARK:- retrieve
    func retrieve(_ myEntityName:String,
                  predicate:String?,
                  sort:[[String:Bool]]?,
                  limit:Int?) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: myEntityName)
        
        // predicate
        if let myPredicate = predicate {
            request.predicate = NSPredicate(format: myPredicate)
        }
        // sort
        if let mySort = sort {
            var sortArr :[NSSortDescriptor] = []
            for sortCond in mySort {
                for (k, v) in sortCond {
                    sortArr.append(NSSortDescriptor(key: k, ascending: v) )
                }
            }
            request.sortDescriptors = sortArr
        }
        // limit
        if let limitNumber = limit {
            request.fetchLimit = limitNumber
        }
        
        
        do {
            return try myContext.fetch(request) as? [NSManagedObject]
            
        } catch {
            fatalError("\(error)")
        }

    }
    
    //MARK:- update
    func update(_ myEntityName:String,
                predicate:String?,
                attributeInfo:[String:Any]) -> Bool {
        if let results = self.retrieve(myEntityName,
                                       predicate: predicate,
                                       sort: nil,
                                       limit: nil) {
            for result in results {
                for (key,value) in attributeInfo {
                    result.setValue(value, forKey: key)
                }
            }
            
            do {
                try myContext.save()
                
                return true
            } catch {
                fatalError("\(error)")
            }
        }
        
        return false
    }
    
    //MARK:- delete
    func delete( _ myEntityName:String, predicate:String?) -> Bool {
        if let results = self.retrieve(
            myEntityName, predicate: predicate, sort: nil, limit: nil) {
            for result in results {
                myContext.delete(result)
            }
            
            do {
                try myContext.save()
                
                return true
            } catch {
                fatalError("\(error)")
            }
        }
        
        return false
    }
    
    
}
