//
//  SelectTagsViewController.swift
//  TrackIt
//
//  Created by Jason Ji on 5/7/16.
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

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


@objc protocol TagFilterDelegate {
    func didSelectTags(_ tags: [Tag], withType type: TagFilterType)
}

class SelectTagsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var dividerHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: TagFilterDelegate?
    var coreDataManager: CoreDataStackManager?
    var currentFilterType: TagFilterType = .show
    var selectedTags: [Tag] = [] {
        didSet {
            selectedTags.sort { return $0.name < $1.name }
        }
    }
    let emptyDataSetDataSource = EmptyDataSetDataSource(title: "No Tags", dataSetDescription: "Add some tags the next time you add an entry.", verticalOffset: -22.0)
    
    lazy var fetchedResultsController: NSFetchedResultsController<Tag>? = {
        guard let context = self.coreDataManager?.managedObjectContext else { return nil }
        let fetchRequest = NSFetchRequest<Tag>(entityName: "Tag")
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
    
    @IBAction func typeChanged(_ sender: UISegmentedControl) {
        guard let type = TagFilterType(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        currentFilterType = type
        delegate?.didSelectTags(selectedTags, withType: currentFilterType)
    }

}

extension SelectTagsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchedResultsController?.sections?.count > 0 {
            return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! TagCell
        if let tag = fetchedResultsController?.object(at: indexPath) {
            cell.configureWithTag(tag, selected: selectedTags.contains(tag))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = TagFilterType(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        currentFilterType = type
        guard let tag = fetchedResultsController?.object(at: indexPath) else { return }
        if let index = selectedTags.index(of: tag) {
            selectedTags.remove(at: index)
        }
        else {
            selectedTags.append(tag)
        }
        tableView.reloadData()
        delegate?.didSelectTags(selectedTags, withType: currentFilterType)
    }
}
