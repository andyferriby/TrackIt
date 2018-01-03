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
    @objc class func tagWithName(_ name: String, colorIndex: Int, inManagedObjectContext context: NSManagedObjectContext) -> Tag {
        let tag = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: context) as! Tag
        tag.name = name
        tag.colorIndex = NSNumber(value: colorIndex as Int)
        return tag
    }
}
