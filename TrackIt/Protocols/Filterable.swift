//
//  Filterable.swift
//  TrackIt
//
//  Created by Jason Ji on 5/7/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//


@objc protocol Filterable {
    @objc func predicate() -> NSPredicate?
    @objc func filterType() -> FilterType
}

@objc enum FilterType: Int {
    case date, tag
}
