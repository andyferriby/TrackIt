//
//  ManageTagsViewController.swift
//  TrackIt
//
//  Created by Jason Ji on 5/9/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
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


class ManageTagsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var dividerHeightConstraint: NSLayoutConstraint!
    
    @objc var coreDataManager: CoreDataStackManager?
    @objc let emptyDataSetDataSource = EmptyDataSetDataSource(title: "No Tags", dataSetDescription: "Add some tags the next time you add an entry.", verticalOffset: 0)
    
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
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = emptyDataSetDataSource
        tableView.emptyDataSetDelegate = self
        
        tableView.isEditing = true
        dividerHeightConstraint.constant = 0.5
    }
}

extension ManageTagsViewController: UITableViewDelegate, UITableViewDataSource {
    
    @objc func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchedResultsController?.sections?.count > 0 {
            return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
        }
        else {
            return 0
        }
    }
    
    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! TagCell
        if let tag = fetchedResultsController?.object(at: indexPath) {
            cell.configureWithTag(tag, selected: false)
        }
        return cell
    }
    
    @objc func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        
    }
    
    @objc func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let tag = fetchedResultsController?.object(at: indexPath) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "TagWillBeDeleted"), object: self, userInfo: ["name":tag.name!])
            coreDataManager?.managedObjectContext.delete(tag)
            coreDataManager?.save()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "TagWasDeleted"), object: self)
        }
    }
}

extension ManageTagsViewController: NSFetchedResultsControllerDelegate {
    @objc func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    @objc func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    @objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath], with: .fade)
        default: break
        }
    }
}

extension ManageTagsViewController: DZNEmptyDataSetDelegate {
    @objc func emptyDataSetWillAppear(_ scrollView: UIScrollView!) {
        warningView.isHidden = true
    }
    @objc func emptyDataSetWillDisappear(_ scrollView: UIScrollView!) {
        warningView.isHidden = false
    }
}
