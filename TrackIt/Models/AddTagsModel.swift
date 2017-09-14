//
//  AddTagsViewModel.swift
//  TrackIt
//
//  Created by Jason Ji on 4/27/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class AddTagsModel {
    var allTags: [Tag] = []
    var tags: [Tag] = [] {
        didSet {
            tags.sort { $0.name < $1.name }
        }
    }
    var coreDataManager: CoreDataStackManager?
    
    init(coreDataManager: CoreDataStackManager) {
        self.coreDataManager = coreDataManager
        allTags = refreshAllTags()
        
    }
    
    @objc func tryAddTag(_ tagName: String) {
        guard let context = coreDataManager?.managedObjectContext else { return }
        
        let fetch = NSFetchRequest<Tag>(entityName: "Tag")
        fetch.predicate = NSPredicate(format: "name == %@", tagName)
        guard let results = try? context.fetch(fetch) else { return }
        if let first = results.first {
            tags.append(first)
            tags.sort { $0.name < $1.name }
        }
        else {
            let colorIndex = ColorManager.firstAvailableColorIndex(allTags)
            let tag = Tag.tagWithName(tagName, colorIndex: colorIndex, inManagedObjectContext: context)
            tags.append(tag)
            allTags = refreshAllTags()
        }
    }
    
    @objc func removeTag(_ tagName: String) {
        let tag = tags.filter { $0.name == tagName }.first
        if let tag = tag {
            tags.remove(at: tags.index(of: tag)!)
        }
    }
    
    @objc func didSelectTagAtIndex(_ index: Int) {
        guard index < allTags.count else { return }
        let tag = allTags[index]
        if tags.contains(tag) {
            tags.remove(at: tags.index(of: tag)!)
        }
        else {
            tags.append(allTags[index])
        }
    }
    
    @objc func refreshAllTags() -> [Tag] {
        guard let context = coreDataManager?.managedObjectContext else { return [] }

        let fetchRequest = NSFetchRequest<Tag>(entityName: "Tag")
        var result = try? context.fetch(fetchRequest)
        result?.sort { $0.name < $1.name }
        return result ?? []
    }
    
    @objc func containsTag(_ tag: String) -> Bool {
        return tags.map { t in return t.name }.filter { $0 == tag }.count == 1
    }
}
