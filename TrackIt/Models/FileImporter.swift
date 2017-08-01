//
//  FileImporter.swift
//  TrackIt
//
//  Created by Jason Ji on 7/31/17.
//  Copyright © 2017 Jason Ji. All rights reserved.
//

import Foundation
import CSwiftV

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

@objc public class FileImporter: NSObject {
    
    weak var delegate: EntryDelegate?
    
    static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM/dd/yy"
        return f
    }()
    
    public func importEntries(from url: URL) throws {
        let pathExtension = url.pathExtension
        switch pathExtension {
        case "csv":
            try importCSVEntries(from: url)
        default: break
        }
    }
    
    private func importCSVEntries(from url: URL) throws {
        let csvString = try String(contentsOf: url)
        let csv = CSwiftV(with: csvString)
        
        var newEntries: [Entry] = []
        
        let context = CoreDataStackManager.sharedInstance.managedObjectContext
        var allTags = CoreDataStackManager.sharedInstance.allTags()
        
        try csv.rows.forEach { row in
            let dateString = row[0]
            let amountString = row[1]
            let descriptionString = row[2]
            let tagString = row[3]
            
            guard let amount = Double(amountString) else {
                throw "Couldn't parse the amount for this entry"
            }
            guard let date = FileImporter.dateFormatter.date(from: dateString) else {
                throw "Unrecognizable date - found \(dateString), but must be in format MM/dd/yy"
            }
            
            let thisTag: Tag
            if let tag = allTags.filter({ $0.name == tagString }).first {
                thisTag = tag
            }
            else {
                let colorIndex = ColorManager.firstAvailableColorIndex(allTags)
                thisTag = Tag.tagWithName(tagString, colorIndex: colorIndex, inManagedObjectContext: context)
                allTags.append(thisTag)
            }
            
            let entry = Entry.entry(withAmount: NSNumber(value: amount), note: descriptionString, date: date, tags: [thisTag], inManagedObjectContext: context)
            newEntries.append(entry)
        }
        CoreDataStackManager.sharedInstance.save()
        delegate?.entryAddedOrChanged()
        
    }
}

extension CoreDataStackManager {
    func allTags() -> [Tag] {
        let fetchRequest = Tag.fetchRequest()
        if let tags = try? managedObjectContext.fetch(fetchRequest) as! [Tag] {
            return tags
        }
        return []
    }
}
