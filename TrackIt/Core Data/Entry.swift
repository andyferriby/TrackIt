//
//  Entry.swift
//  TrackIt
//
//  Created by Jason Ji on 4/25/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import Foundation
import CoreData

@objc(Entry)
class Entry: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    class func entry(withAmount amount: NSNumber?, note: String?, date: Date?, tags: [Tag]?, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Entry {
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: managedObjectContext) as! Entry
        
        entry.amount = amount
        entry.note = note
        entry.date = date
        if let tags = tags {
            entry.tags = NSSet(array: tags)
        }
        
        return entry
    }
}
