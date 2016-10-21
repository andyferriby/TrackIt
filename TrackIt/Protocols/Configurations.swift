//
//  Cell+ConfigureWithEntry.swift
//  TrackIt
//
//  Created by Jason Ji on 4/26/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

@objc protocol EntryConfigurable {
    @objc optional func configureWithEntry(_ entry: Entry)
    @objc optional func configureWithEntry(_ entry: Entry, numberFormatter: NumberFormatter)
}

@objc protocol TagConfigurable {
    @objc optional func configureWithTags(_ tags: [Tag])
    @objc optional func configureWithTag(_ tag: Tag, selected: Bool)
}
