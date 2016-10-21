//
//  Filterable.swift
//  TrackIt
//
//  Created by Jason Ji on 5/4/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import DateTools

// MARK: Date Filters

@objc enum DateFilterType: Int {
    case last7Days, thisMonth, allTime, dateRange
}

@objc class DateFilter: NSObject {
    var type: DateFilterType
    var startDate: Date?
    var endDate: Date?
    
    init(type: DateFilterType) {
        self.type = type
    }
    
    init(type: DateFilterType, startDate: Date, endDate: Date) {
        self.type = type
        // Start at midnight on startDate, end at midnight on endDate+1 day
        self.startDate = NSDate(year: (startDate as NSDate).year(), month: (startDate as NSDate).month(), day: (startDate as NSDate).day()) as Date?
        self.endDate = NSDate(year: (endDate as NSDate).year(), month: (endDate as NSDate).month(), day: (endDate as NSDate).day()+1) as Date?
    }
    
    func filterType() -> FilterType {
        return .date
    }
}

extension DateFilter: Filterable {
    func predicate() -> NSPredicate? {
        switch(type) {
        case .last7Days:
            let lowerBoundary = (Date() as NSDate).subtractingDays(7)
            return NSPredicate(format: "date > %@", lowerBoundary as! CVarArg)
        case  .thisMonth:
            let now = Date()
            let lowerBoundary = NSDate(year: (now as NSDate).year(), month: (now as NSDate).month(), day: 1)
            return NSPredicate(format: "date > %@", lowerBoundary!)
        case .allTime:
            return nil
        case .dateRange:
            guard let startDate = startDate, let endDate = endDate else { return nil }
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "date > %@", startDate as CVarArg),
                NSPredicate(format: "date < %@", endDate as CVarArg)
                ])
        }
    }
}

// MARK: Tag Filters

@objc enum TagFilterType: Int {
    case show, hide
}

@objc class TagFilter: NSObject {
    var type: TagFilterType
    var tags: [Tag]
    init(type: TagFilterType, tags: [Tag]) {
        self.type = type
        self.tags = tags
    }
}

extension TagFilter: Filterable {
    func predicate() -> NSPredicate? {
        switch type {
        case .show:
            return tags.count == 0 ? nil : NSPredicate(format: "ANY tags IN %@", tags)
        case .hide:
            return tags.count == 0 ? nil : NSPredicate(format: "tags.@count == 0 OR (NOT (ANY tags IN %@))", tags)
        }
        
    }
    func filterType() -> FilterType {
        return .tag
    }
}



