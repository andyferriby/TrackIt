//
//  CoreDataStack.swift
//  TrackIt
//
//  Created by Jason Ji on 5/9/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

@objc class CoreDataStackManager: NSObject {
    @objc static let sharedInstance = CoreDataStackManager()
    
    var applicationDocumentsDirectory = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    @objc let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    fileprivate let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    @objc override init() {
        super.init()
        initializeCoreData()
    }
    
    @objc func initializeCoreData() {
        guard let modelURL = Bundle.main.url(forResource: "TrackIt", withExtension: "momd") else { fatalError("Invalid model URL") }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else { fatalError("Invalid model") }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        let storeURL: URL = applicationDocumentsDirectory.appendingPathComponent("TrackIt.sqlite")
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                           NSInferMappingModelAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        }catch {
            fatalError("Could not add the persistent store: \(error).")
        }
        
        privateContext.persistentStoreCoordinator = coordinator
        managedObjectContext.parent = privateContext
    }
    
    @objc func save() {
        if !privateContext.hasChanges && !self.managedObjectContext.hasChanges {
            return
        }
        managedObjectContext.performAndWait {
            do {
                try self.managedObjectContext.save()
                self.privateContext.perform {
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
    
    @objc func saveWithTemporaryContext(_ context: NSManagedObjectContext) {
        // Assumes the passed context has our managedObjectContext as its parent.
        if !context.hasChanges {
            return
        }
        context.performAndWait {
            do {
                try context.save()
                self.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
