//
//  Cell+ConfigureWithEntry.swift
//  TrackIt
//
//  Created by Jason Ji on 4/26/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

@objc protocol EntryConfigurable {
    optional func configureWithEntry(entry: Entry)
    optional func configureWithEntry(entry: Entry, numberFormatter: NSNumberFormatter)
}

@objc protocol TagConfigurable {
    optional func configureWithTags(tags: [Tag])
    optional func configureWithTag(tag: Tag, selected: Bool)
}