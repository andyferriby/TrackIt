//
//  Entry+CoreDataProperties.swift
//  TrackIt
//
//  Created by Jason Ji on 4/25/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Entry {

    @NSManaged var amount: NSNumber?
    @NSManaged var date: NSDate?
    @NSManaged var note: String?
    @NSManaged var tags: NSSet?

}
