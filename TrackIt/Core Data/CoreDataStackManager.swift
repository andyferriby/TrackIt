//
//  CoreDataStack.swift
//  TrackIt
//
//  Created by Jason Ji on 5/9/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

class CoreDataStackManager: NSObject {
    static let sharedInstance = CoreDataStackManager()
    
    var applicationDocumentsDirectory = {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    }()
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    private let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    
    override init() {
        super.init()
        initializeCoreData()
    }
    
    func initializeCoreData() {
        guard let modelURL = NSBundle.mainBundle().URLForResource("TrackIt", withExtension: "momd") else { fatalError("Invalid model URL") }
        guard let model = NSManagedObjectModel(contentsOfURL: modelURL) else { fatalError("Invalid model") }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        let storeURL: NSURL = applicationDocumentsDirectory.URLByAppendingPathComponent("TrackIt.sqlite")
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                           NSInferMappingModelAutomaticallyOption: true]
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
        }catch {
            fatalError("Could not add the persistent store: \(error).")
        }
        
        privateContext.persistentStoreCoordinator = coordinator
        managedObjectContext.parentContext = privateContext
    }
    
    func save() {
        if !privateContext.hasChanges && !self.managedObjectContext.hasChanges {
            return
        }
        managedObjectContext.performBlockAndWait {
            do {
                try self.managedObjectContext.save()
                self.privateContext.performBlock {
                    do {
                        try self.privateContext.save()
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}