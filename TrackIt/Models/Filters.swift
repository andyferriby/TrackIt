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
    case Last7Days, ThisMonth, AllTime, DateRange
}

@objc class DateFilter: NSObject {
    var type: DateFilterType
    var startDate: NSDate?
    var endDate: NSDate?
    
    init(type: DateFilterType) {
        self.type = type
    }
    
    init(type: DateFilterType, startDate: NSDate, endDate: NSDate) {
        self.type = type
        // Start at midnight on startDate, end at midnight on endDate+1 day
        self.startDate = NSDate(year: startDate.year(), month: startDate.month(), day: startDate.day())
        self.endDate = NSDate(year: endDate.year(), month: endDate.month(), day: endDate.day()+1)
    }
    
    func filterType() -> FilterType {
        return .Date
    }
}

extension DateFilter: Filterable {
    func predicate() -> NSPredicate? {
        switch(type) {
        case .Last7Days:
            let lowerBoundary = NSDate().dateBySubtractingDays(7)
            return NSPredicate(format: "date > %@", lowerBoundary)
        case  .ThisMonth:
            let now = NSDate()
            let lowerBoundary = NSDate(year: now.year(), month: now.month(), day: 1)
            return NSPredicate(format: "date > %@", lowerBoundary)
        case .AllTime:
            return nil
        case .DateRange:
            guard let startDate = startDate, endDate = endDate else { return nil }
            return NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "date > %@", startDate),
                NSPredicate(format: "date < %@", endDate)
                ])
        }
    }
}

// MARK: Tag Filters

@objc enum TagFilterType: Int {
    case Show, Hide
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
        case .Show:
            return tags.count == 0 ? nil : NSPredicate(format: "ANY tags IN %@", tags)
        case .Hide:
            return tags.count == 0 ? nil : NSPredicate(format: "tags.@count == 0 OR (NOT (ANY tags IN %@))", tags)
        }
        
    }
    func filterType() -> FilterType {
        return .Tag
    }
}



