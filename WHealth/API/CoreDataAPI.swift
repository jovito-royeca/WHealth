//
//  CoreDataAPI.swift
//  WHealth
//
//  Created by Jovito Royeca on 12.10.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import Sync

enum Notifications {
    static let JSON2CoreDataDone = "JSON2CoreDataDone"
}

/*
 * Singleton class to handle Core Data operations
 */
class CoreDataAPI: NSObject {
    // MARK: - Shared Instance
    static let sharedInstance = CoreDataAPI()
    
    // MARK: Variables
    /*
     * Uses SyncDB to simplify mapping JSON to Core Data.
     * This is the main context of Core Data and is used for saving and retrieving data.
     */
    fileprivate var _dataStack:DataStack?
    var dataStack:DataStack? {
        get {
            if _dataStack == nil {
                _dataStack = DataStack(modelName: "WHealth")
            }
            return _dataStack
        }
        set {
            _dataStack = newValue
        }
    }
    
    /*
     * Save pending updates, if there is any.
     */
    func saveContext() {
        guard let dataStack = dataStack else {
            return
        }
        
        if dataStack.mainContext.hasChanges {
            do {
                try dataStack.mainContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /*
     * Read JSON data
     */
    func loadData() -> [[String: Any]]? {
        guard let path = Bundle.main.path(forResource: "topics",
                                          ofType: "json",
                                          inDirectory: "data"),
            FileManager.default.fileExists(atPath: path) else {
                return nil
        }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        
        guard let array = try! JSONSerialization.jsonObject(with: data,
                                                            options: .allowFragments) as? [[String: Any]] else {
            return nil
        }
        
        return array
    }
    
    /*
     * Load JSON data to database
     */
    func json2CoreData() {
        guard let array = loadData() else {
            return
        }
        
        let notifName = NSNotification.Name.NSManagedObjectContextObjectsDidChange
        
        dataStack?.performInNewBackgroundContext { backgroundContext in
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.changeNotification(_:)),
                                                   name: notifName,
                                                   object: backgroundContext)
            
            Sync.changes(array,
                         inEntityNamed: "Topic",
                         predicate: nil,
                         parent: nil,
                         parentRelationship: nil,
                         inContext: backgroundContext,
                         operations: .all,
                         completion:  { error in
                            NotificationCenter.default.removeObserver(self, name:notifName,
                                                                      object: nil)
                            NotificationCenter.default.post(name: Notification.Name(Notifications.JSON2CoreDataDone),
                                                            object: nil)
            })
        }
    }
    
    /*
     * Listeners
     */
    @objc func changeNotification(_ notification: Notification) {
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] {
            if let set = updatedObjects as? NSSet {
                print("updatedObjects: \(set.count)")
            }
        }
        
        if let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] {
            if let set = deletedObjects as? NSSet {
                print("deletedObjects: \(set.count)")
            }
        }
        
        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] {
            if let set = insertedObjects as? NSSet {
                print("insertedObjects: \(set.count)")
            }
        }
    }
}
