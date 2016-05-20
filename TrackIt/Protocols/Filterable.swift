//
//  Filterable.swift
//  TrackIt
//
//  Created by Jason Ji on 5/7/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//


@objc protocol Filterable {
    func predicate() -> NSPredicate?
    func filterType() -> FilterType
}

@objc enum FilterType: Int {
    case Date, Tag
}