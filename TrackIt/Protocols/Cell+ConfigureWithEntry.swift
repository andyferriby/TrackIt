//
//  Cell+ConfigureWithEntry.swift
//  TrackIt
//
//  Created by Jason Ji on 4/26/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

@objc protocol Configurable {
    
    func configureWithEntry(entry: Entry)

}