//
//  Tag+CoreDataProperties.swift
//  TrackIt
//
//  Created by Jason Ji on 5/3/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tag {

    @NSManaged var name: String?
    @NSManaged var colorIndex: NSNumber?
    @NSManaged var entries: NSSet?

}
