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

    class func entry(withAmount amount: NSNumber?, note: String?, date: NSDate?, tags: [Tag]?, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Entry {
        let entry = NSEntityDescription.insertNewObjectForEntityForName("Entry", inManagedObjectContext: managedObjectContext) as! Entry
        
        entry.amount = amount
        entry.note = note
        entry.date = date
        
        return entry
    }
}