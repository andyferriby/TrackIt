//
//  EntriesModel.swift
//  TrackIt
//
//  Created by Jason Ji on 5/4/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

class EntriesModel: NSObject {
    
    fileprivate var entries: [Entry] = []
    fileprivate var filters: [Filterable]
    fileprivate var coreDataManager: CoreDataStackManager
    
    init(filters: [Filterable], coreDataManager: CoreDataStackManager) {
        self.filters = filters
        self.coreDataManager = coreDataManager
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCurrentFilters), name: NSNotification.Name(rawValue: "TagWillBeDeleted"), object: nil)
    }
    
    func numberOfEntries() -> Int {
        return entries.count
    }
    
    func entryAt(_ index: Int) -> Entry {
        return entries[index]
    }
    
    func deleteEntryAt(_ index: Int) {
        let entry = entries[index]
        coreDataManager.managedObjectContext.delete(entry)
        coreDataManager.save()

        refreshEntries()
    }
    
    func totalSpending() -> NSNumber {
        let total = entries.reduce(0, {
            $0 + $1.amount!.doubleValue
        })
        return NSNumber(value: total as Double)
    }
    
    func refreshEntries() {
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filters.map { return $0.predicate()! })

        do {
            entries = try coreDataManager.managedObjectContext.fetch(fetchRequest)
            entries.sort { $0.date!.compare($1.date!) == .orderedAscending }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func refreshCurrentFilters(_ notification: Notification) {
        for filter in filters {
            switch filter.filterType() {
            case .date: break
            case .tag:
                guard let filter = filter as? TagFilter else { continue }
                let deletedTagName = (notification as NSNotification).userInfo?["name"] as! String
                filter.tags = filter.tags.filter { return $0.name! != deletedTagName }
            }
        }
        filters = filters.filter { $0.predicate() != nil }
        refreshEntries()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ModelFiltersUpdated"), object: self)  
    }
    
    func refreshWithFilters(_ newFilters: [Filterable]) {
        for filter in newFilters {
            filters = filters.filter { return $0.filterType() != filter.filterType() }
            filters.append(filter)
        }
        filters = filters.filter { $0.predicate() != nil }
        refreshEntries()
    }
    
    func currentTagFilter() -> TagFilter? {
        return filters.filter { return $0.filterType() == .tag }.first as? TagFilter ?? nil
    }

}

