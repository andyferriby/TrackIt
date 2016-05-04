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
    class func tagWithName(name: String, colorIndex: Int, inManagedObjectContext context: NSManagedObjectContext) -> Tag {
        let tag = NSEntityDescription.insertNewObjectForEntityForName("Tag", inManagedObjectContext: context) as! Tag
        tag.name = name
        tag.colorIndex = NSNumber(integer: colorIndex)
        return tag
    }
}
