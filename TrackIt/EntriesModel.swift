//
//  EntriesModel.swift
//  TrackIt
//
//  Created by Jason Ji on 5/4/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

class EntriesModel: NSObject {
    
    private var entries: [Entry] = []
    private var filters: [Filterable]
    private var context: NSManagedObjectContext
    
    init(filters: [Filterable], context: NSManagedObjectContext) {
        self.filters = filters
        self.context = context
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshCurrentFilters), name: "TagWillBeDeleted", object: nil)
    }
    
    func numberOfEntries() -> Int {
        return entries.count
    }
    
    func entryAt(index: Int) -> Entry {
        return entries[index]
    }
    
    func deleteEntryAt(index: Int) {
        let entry = entries[index]
        do {
            context.deleteObject(entry)
            try context.save()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        refreshEntries()
    }
    
    func totalSpending() -> NSNumber {
        let total = entries.reduce(0, combine: {
            $0 + $1.amount!.doubleValue
        })
        return NSNumber(double: total)
    }
    
    func refreshEntries() {
        let fetchRequest = NSFetchRequest(entityName: "Entry")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filters.map { return $0.predicate()! })

        do {
            entries = try context.executeFetchRequest(fetchRequest) as! [Entry]
            entries.sortInPlace { $0.date!.compare($1.date!) == .OrderedAscending }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func refreshCurrentFilters(notification: NSNotification) {
        for filter in filters {
            switch filter.filterType() {
            case .Date: break
            case .Tag:
                guard let filter = filter as? TagFilter else { continue }
                let deletedTagName = notification.userInfo?["name"] as! String
                filter.tags = filter.tags.filter { return $0.name! != deletedTagName }
            }
        }
        filters = filters.filter { $0.predicate() != nil }
        refreshEntries()
        NSNotificationCenter.defaultCenter().postNotificationName("ModelFiltersUpdated", object: self)  
    }
    
    func refreshWithFilters(newFilters: [Filterable]) {
        for filter in newFilters {
            filters = filters.filter { return $0.filterType() != filter.filterType() }
            filters.append(filter)
        }
        filters = filters.filter { $0.predicate() != nil }
        refreshEntries()
    }
    
    func currentTagFilter() -> TagFilter? {
        return filters.filter { return $0.filterType() == .Tag }.first as? TagFilter ?? nil
    }

}

