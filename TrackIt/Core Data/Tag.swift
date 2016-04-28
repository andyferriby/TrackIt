//
//  Tag.swift
//  TrackIt
//
//  Created by Jason Ji on 4/25/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import CoreData


class Tag: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    class func tagWithName(name: String, inManagedObjectContext context: NSManagedObjectContext) -> Tag {
//        let tag = NSEntityDescription.insert
        let tag = NSEntityDescription.insertNewObjectForEntityForName("Tag", inManagedObjectContext: context) as! Tag
        tag.name = name
        return tag
    }
}
