//
//  SelectTagsViewController.swift
//  TrackIt
//
//  Created by Jason Ji on 5/7/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

@objc protocol TagFilterDelegate {
    func didSelectTags(tags: [Tag], withType type: TagFilterType)
}

class SelectTagsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var dividerHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: TagFilterDelegate?
    var coreDataManager: CoreDataStackManager?
    var currentFilterType: TagFilterType = .Show
    var selectedTags: [Tag] = [] {
        didSet {
            selectedTags.sortInPlace { return $0.name < $1.name }
        }
    }
    let emptyDataSetDataSource = EmptyDataSetDataSource(title: "No Tags", dataSetDescription: "Add some tags the next time you add an entry.", verticalOffset: -22.0)
    
    lazy var fetchedResultsController: NSFetchedResultsController? = { [unowned self] in
        guard let context = self.coreDataManager?.managedObjectContext else { return nil }
        let fetchRequest = NSFetchRequest(entityName: "Tag")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
           try controller.performFetch()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dividerHeightConstraint.constant = 0.5
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = emptyDataSetDataSource
        
        segmentedControl.selectedSegmentIndex = currentFilterType.rawValue
    }
}

extension SelectTagsViewController {
    
    @IBAction func typeChanged(sender: UISegmentedControl) {
        guard let type = TagFilterType(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        currentFilterType = type
        delegate?.didSelectTags(selectedTags, withType: currentFilterType)
    }

}

extension SelectTagsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchedResultsController?.sections?.count > 0 {
            return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tag = fetchedResultsController?.objectAtIndexPath(indexPath) as! Tag
        let cell = tableView.dequeueReusableCellWithIdentifier("tagCell", forIndexPath: indexPath) as! TagCell
        cell.configureWithTag(tag, selected: selectedTags.contains(tag) ?? false)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let type = TagFilterType(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        currentFilterType = type
        let tag = fetchedResultsController?.objectAtIndexPath(indexPath) as! Tag
        if let index = selectedTags.indexOf(tag) {
            selectedTags.removeAtIndex(index)
        }
        else {
            selectedTags.append(tag)
        }
        tableView.reloadData()
        delegate?.didSelectTags(selectedTags, withType: currentFilterType)
    }
}